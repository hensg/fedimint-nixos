{ lib
, modulesPath
, diskEncrypted ? true
, ...
}:
let
  authorizedKeys = builtins.attrValues (import ../../_users).users;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../_common
    ../../_core
    ./encrypted-disks.nix
  ];
  ##++ (lib.mkIf diskEncrypted [ ./encrypted-disk ])
  ##++ (lib.mkIf (!diskEncrypted) ./unecrypted-disks.nix ]);

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        enableCryptodisk = diskEncrypted;
      };
    };

    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];

      network = lib.mkIf diskEncrypted {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = [ "/etc/ssh/ssh_host_ed25519_key" ];
          inherit authorizedKeys;
        };
        postCommands = ''
          echo 'cryptsetup-askpass' >> /root/.profile
        '';
      };
    };
  };
  users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

  networking.hostName = "nixos";

  system.stateVersion = " 24.05 ";
}
