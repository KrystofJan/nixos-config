{ config, pkgs, inputs, ... }:

{
  imports =
    [
	../../modules/hosts/hosts.nix
        ../../main-user.nix
        ../../modules/must-haves/must-haves.nix
        ../../modules/hyprland/hyprland.nix
        ../../modules/bootloader/grub.nix
        ../../modules/obs/obs.nix 
        ./hardware-configuration.nix
	./gc/gc.nix
	./virtualization/docker.nix
	./virtualization/virtualbox.nix
    ];

  main-user.enable = true;
  main-user.userName = "zahry";

  # SWAP
  swapDevices = [{
    device = "/swap";
    size = 16 * 1024; #16GB
  }];

  networking.hostName = "perun";

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  time.timeZone = "Europe/Prague";

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

  # Set up zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default

    # Cli
    ghostty

    # Apps
    firefox
    discord
    obsidian
    spotify
    slack
    vscode
    postman

    # Dev
    pkgs.vim 
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

  system.stateVersion = "23.11";
}
