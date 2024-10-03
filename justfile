# Command to install/format a new VPS
format USER_AT_HOST CONFIG:
   @echo "Starting to format host in 5s... CTRL+C to cancel...".
   sleep 5
   nix run github:nix-community/nixos-anywhere -- --build-host --copy-host-keys --flake .#{{CONFIG}} {{USER_AT_HOST}}

# Command to update the host
update USER_AT_HOST CONFIG:
    nixos-rebuild switch --flake .#{{CONFIG}} --target-host {{USER_AT_HOST}}
