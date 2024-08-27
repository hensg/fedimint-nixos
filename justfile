# Command to install/format a new VPS
format USER_AT_HOST CONFIG:
    @read -p "Are you sure you want to format the host? [y/N] " confirmation; \
    if [ "$confirmation" = "y" ] || [ "$confirmation" = "Y" ]; then \
        echo "Formatting host..."; \
        nix run github:nix-community/nixos-anywhere -- --flake .#{{CONFIG}} {{USER_AT_HOST}}
    else \
        echo "Format aborted."; \
    fi

# Command to update the host
update USER_AT_HOST CONFIG:
    nixos-rebuild switch --flake .#{{CONFIG}} --target-host {{USER_AT_HOST}}
