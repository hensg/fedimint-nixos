{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disks.nix
    ../../_common
    ../../_core
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        enableCryptodisk = true;
        device = "/dev/sda";
      };
    };

    initrd = {
      availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = ["/etc/ssh/ssh_host_ed25519_key"];
          authorizedKeys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL4tSejx2D5owCxNYRYR3ZMj2MKlVrcvBxKoDiXqKiWAKjOMBOJZ3snUYsT7A3qD0N+wNUBvCVpPip4pGGvzj7DPCVNMBISL70HkMTzcgT+5gKoA+q1vJDNphXbRhiQUC3NH1fhPAoFeAxzirtegAOqXVA9n7Ekm5X/pXA+uzVvFtbmJd092kXFjLXk2aybUcI1QKJ5EVt7ot/R/T1u0aaP89uU3bJi0wf8gw7TU6DiQY8bm6TyOqCuJ5tx5y9z6Xo8zd/Im2UE6k6hsPlRM3+8n98XaW2taNVfG/Xk0ePm1extbqDXQd3jZmur0aASCnMymuyn5/9jJDf7Z3VD/SijcDki3O1j1q+5psqv9pI/DG7v3QJwUrcj81gVEwdM0BxJ8q13O27dfGsaxpM8P8IfvJdZIU2T8Psqx7skUX5PDh9Gy9YMtZBkwgK8F1+j4YeszsaPSWa+2+2LU2ue0awjcNMWGqw12M7PlQ4gg0RihkC77vwpPCG15ErZJ3c6jRpZkaU9M7rHOCOSI5eCSOA/Km7U0qqsBtteaJ+a2V1IiZs9ygGQ4ENJUsAUikyRfqKki4fpA/dUY7HZjj3W8GKlIeg+pR6UJpSt2blc1PKRVoC9QyhqeuqQ/AEU3cGIytRH/6+N8BZrHZ2YG4Fg2NcyrIn3kKsu402EkwV0Yfrmw== cardno:25 331 213";
        };
        postCommands = ''
          echo 'cryptsetup-askpass' >> /root/.profile
        '';
      };
    };
  };
  #users.users.root.openssh.authorizedKeys.keys = authorizedKeys;

  system.stateVersion = " 24.05 ";
}
