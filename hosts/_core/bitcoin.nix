{ operator
, prune ? 1000
, dbCache ? 1000
, ...
}:
{
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
