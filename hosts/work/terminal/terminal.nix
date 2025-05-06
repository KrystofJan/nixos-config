{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Emulators
    alacritty
    foot
    kitty

    #Apps
    zsh-powerlevel10k
    zellij
    fzf
    fd
    thefuck
    zoxide
    atuin
    eza
    bat
    btop
    neofetch
    yazi
    act
    cowsay
    lazygit
    starship
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}
