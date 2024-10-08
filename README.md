# Fedimint NixOS Deployment

Requirements:
- [just](https://github.com/casey/just)
 

## Infrastructure Setup on Hetzner
This section provides a summary of how to install NixOS with Fedimint and Bitcoin on a Hetzner VPS.

### Formatting the Machine
It uses the ssh-key from `hosts/_users/default.nix` as ssh password is disable.

```shell
just format user@ip hetzner
```
This command uses nixos-anywhere to start the installation process. You will be prompted to enter a password to encrypt the disk.

After the machine reboots for the installation, the disk will be locked and needs to be unlocked by entering the passphrase after SSH into init boot:
```shell
ssh -p 2222 user@ip
```
This unlocks the disk and continues the boot process. Your SSH session will be dropped since port 2222 is used only for boot disk unlocking.

Once the boot process is complete, you can access the machine with:
port is meant only for boot disk unlock.
```shell
ssh -p 22 user@ip
```

### Updating the VPS with New NixOS config

```shell
just update user@ip hetzner
```

### Troubleshooting

#### Wrong disk device (not /dev/sda)

If necessary, update the disk device in `hosts/hetzner/vps/encrypted-disks.nix`


## DNS

Here is my configuration for DNS records setup:

| Type     | Host  | Value         |
|----------|-------|---------------|
| A Record | @     | [IP-REDACTED] |
| A Record | admin | [IP-REDACTED] |
| A Record | api   | [IP-REDACTED] |
| A Record | p2p   | [IP-REDACTED] |


## Connecting guardians

1. Go to the Admin URL: `https://$fmAdminFqdn` (e.g.: `https://admin.myhost/`).
2. Click `Connnect a Service` and nenter the address: `wss://$fmApiFqdn/ws/` (e.g. `wss://api.myhost/ws/`).

*Note*: Don’t forget the trailing / in the URL, or it may not work.
