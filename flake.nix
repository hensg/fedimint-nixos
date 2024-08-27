{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko = {
      url = "github:nix-community/disko";
    };
    fedimint = {
      # CHANGEME: change to a version you'd like to use
      # url = "github:fedimint/fedimint?ref=refs/tags/v0.3.1";
      #url = "github:fedimint/fedimint?ref=refs/tags/v0.4.2.rc0";
      url = "github:fedimint/fedimint?rev=45add3342c72bf3237256aa85d3120d3ceb0930c";
    };
    fedimint-ui = {
      url = "github:fedimint/ui?rev=b57151db3bc4afa373cd61d67b8677e0ba38ceeb";
    };
    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/release";
    };
  };

  nixConfig = {
    extra-substituters = ["https://fedimint.cachix.org"];
    extra-trusted-public-keys = ["fedimint.cachix.org-1:FpJJjy1iPVlvyv4OMiN5y9+/arFLPcnZhZVVCHCDYTs="];
  };

  outputs = {
    nixpkgs,
    disko,
    fedimint,
    fedimint-ui,
    nix-bitcoin,
    ...
  } @ inputs: let
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
        nixPath = ["nixpkgs=${nixpkgs}"];
      };
    };
  in {
    nixosConfigurations = {
      hetzner = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
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
