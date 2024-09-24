# Fedimint NixOS deployment on Hetzner

This version runs with encrypted disk.
Be aware that there is two different ports for `SSH`:
1. -p 2222: secure boot ssh that unlock the disk whenever the system is restarted
2. -p 22: normal ssh to the system
