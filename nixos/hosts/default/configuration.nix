# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
        ../../main-user.nix
        ../../modules/must-haves/must-haves.nix
        ../../modules/hyprland/hyprland.nix
        ../../modules/bootloader/grub.nix
        ../../modules/obs/obs.nix 
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ];

  main-user.enable = true;
  main-user.userName = "zahry";

  # SWAP
  swapDevices = [{
    device = "/swap";
    size = 16 * 1024; #16GB
  }];

  networking.hostName = "perun"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "zahry" = import ./home.nix;
    };
  };

  # Set up zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;


  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vboxusers.members = [ "zahry" ];
  users.extraGroups.docker.members = [ "zahry" ];

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.specific
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    # Cli
    ghostty
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
    ripgrep

    # Apps
    pkgs.firefox
    discord
    obsidian
    spotify
    slack
    vscode
    jetbrains.datagrip
    jetbrains.rider
    postman

    # Dev
    pkgs.vim 
    neovim
    git
    gcc
    lazygit
    gnumake
    killall
    wget
  ];

  programs.git = {
    enable = true;
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
