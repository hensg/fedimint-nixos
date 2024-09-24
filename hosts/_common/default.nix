{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    unzip
    git
    neovim
    yarn
  ];

  networking = {
    firewall = {
      allowPing = true;
      allowedTCPPorts = [
        22
        2222
        80
        443
        8173
      ];
    };
  };

  services.resolved.enable = true;

  services = {
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    journald.extraConfig = "SystemMaxUse=1G";
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes repl-flake
    '';
    settings = {
      max-jobs = "auto";
      auto-optimise-store = true;
    };
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
    daemonCPUSchedPolicy = "idle";

    gc = {
      automatic = true;
      persistent = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };

    settings = {
      keep-derivations = lib.mkForce false;
      keep-outputs = lib.mkForce false;
    };
  };

}
