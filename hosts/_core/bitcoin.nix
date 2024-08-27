{...}: let
  operator = "henrique";
  prune = 550;
  dbCache = 2200;
in {
  nix-bitcoin = {
    generateSecrets = true;
    operator = {
      enable = true;
      name = operator;
    };
  };

  services.bitcoind = {
    enable = true;
    inherit prune dbCache;
  };
}
