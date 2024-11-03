{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    fedimint.url = "github:fedimint/fedimint?ref=refs/tags/v0.4.3";
    #fedimint-ui.url = "github:fedimint/ui?rev=b57151db3bc4afa373cd61d67b8677e0ba38ceeb"; 
    #fedimint-ui.url = "path:///home/henrique/Projects/fedimint-ui";
    fedimint-ui.url = "github:fedimint/ui?rev=70c90a272e763a426965e79c5e8a830f27c23062";
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
