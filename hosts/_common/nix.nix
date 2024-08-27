{lib, ...}: {
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

  services.journald.extraConfig = "SystemMaxUse=1G";
}
