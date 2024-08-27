{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    neovim
  ];
}
