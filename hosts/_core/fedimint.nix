{ pkgs
, fmFqdn
, email
, ...
}:
let
  fmApiFqdn = "api.${fmFqdn}";
  fmP2pFqdn = "p2p.${fmFqdn}";
  fmAdminFqdn = "admin.${fmFqdn}";
in
{
  security.acme.defaults.email = email;
  security.acme.acceptTerms = true;
  users.extraUsers.fedimintd-mainnet.extraGroups = [ "bitcoinrpc-public" ];

  services.fedimintd."mainnet" = {
    enable = true;
    package = pkgs.fedimintd;
    extraEnvironment = {
      "RUST_LOG" = "info";
      "RUST_BACKTRACE" = "1";
      "FM_REL_NOTES_ACK" = "0_4_xyz";
    };
    api.fqdn = fmApiFqdn;
    p2p.fqdn = fmP2pFqdn;
    bitcoin = {
      network = "bitcoin";
      rpc = {
        address = "http://public@127.0.0.1:8332";
        secretFile = "/etc/nix-bitcoin-secrets/bitcoin-rpcpassword-public";
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts."${fmApiFqdn}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8045/";
        extraConfig = "proxy_pass_header Authorization;";
      };
      locations."/ws/" = {
        proxyPass = "http://127.0.0.1:8174/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_pass_header Authorization;
        '';
      };
      locations."= /meta.json" = {
        alias = "/var/www/meta.json";
        extraConfig = ''
          add_header Access-Control-Allow-Origin '*';
        '';
      };
      locations."/federation_assets/" = {
        alias = "/var/www/static/";
        extraConfig = ''
          add_header Access-Control-Allow-Origin '*';
        '';
      };
    };

    virtualHosts."${fmAdminFqdn}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        root = pkgs.fedimint-ui;
      };
      locations."=/config.json" = {
        alias = pkgs.writeText "config.json" ''
          {
            "fm_config_api": "wss://${fmApiFqdn}/ws/",
            "tos": "Terms of Service"
          }
        '';
      };
    };
  };
}
