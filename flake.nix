{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    fedimint.url = "github:fedimint/fedimint?ref=refs/tags/v0.4.3";
    fedimint-ui.url = "github:fedimint/ui?rev=25da5532737f7aa61a29a4ae394ae1bffc1fcd9b";
    nix-bitcoin.url = "github:fort-nix/nix-bitcoin/release";
    disko.url = "github:nix-community/disko";
  };

  nixConfig = {
    extra-substituters = [ "https://fedimint.cachix.org" ];
    extra-trusted-public-keys = [
      "fedimint.cachix.org-1:FpJJjy1iPVlvyv4OMiN5y9+/arFLPcnZhZVVCHCDYTs="
    ];
  };

  outputs =
    { nixpkgs
    , disko
    , fedimint
    , fedimint-ui
    , nix-bitcoin
    , ...
    }@inputs:
    let
      overlays = [
        (final: prev: {
          fedimintd = fedimint.packages.${final.system}.fedimintd;
          fedimint-cli = fedimint.packages.${final.system}.fedimint-cli;
          fedimint-ui = fedimint-ui.packages.${final.system}.guardian-ui;
        })
      ];

      topLevelModule = {
        nixpkgs = {
          inherit overlays;
        };
        nix = {
          registry = {
            nixpkgs.flake = nixpkgs;
          };
          nixPath = [ "nixpkgs = ${nixpkgs}" ];
        };
      };
    in
    {
      nixosConfigurations = {
        hetzner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;

            # fedimint
            fmFqdn = "hensg.dev";
            email = "wololo@hensg.dev";

            # bitcoind
            operator = "henrique";
            dbCache = 2000;
            prune = 5000;

            # TODO: always encrypter for now, this does not work yet
            diskEncrypted = true;
          };

          modules = [
            topLevelModule
            nix-bitcoin.nixosModules.default
            fedimint.nixosModules.fedimintd
            disko.nixosModules.disko

            ./hosts/hetzner/vps/configuration.nix
          ];
        };
      };
    };
}
