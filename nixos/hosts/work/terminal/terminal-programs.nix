{ config, pkgs, lib, ... }:

  # dotfiles = builtins.fetchGit {
  #     url = "github.com:KrystofJan/.dotfiles.git";
  #   rev = "fd006e5ba616b1cec1f37f83bad360422d5d8b25";
  # };

    # dotfiles = "${config.home.homeDirectory}/.dotfiles";
    # alacrittyPath = "${config.home.homeDirectory}/.config/alacritty";
    # atuinPath = "${config.home.homeDirectory}/.config/atuin";
    # zellijPath = "${config.home.homeDirectory}/.config/zellij/";
    # nvimPath = "${config.home.homeDirectory}/.config/nvim/";
{
  home.packages = with pkgs; [
    # Emulators
    alacritty
    foot
    kitty

    #Apps
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
  

    # home.file = {
    #     ${zellijPath}.source = "${dotfiles}/.config/zellij";
    #     ${nvimPath}.source = "${dotfiles}/.config/nvim";
    #     ${atuinPath}.source = "${dotfiles}/.config/atuin";
    # };
}
