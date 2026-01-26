# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.

    ../../modules/window-manager/waygang.nix
    ../../modules/bootloader/bootGrub.nix
    ../../modules/usb-notifications/usb-notifications.nix
    ../../main-user.nix
    ./hardware-configuration.nix
  ];

  main-user.enable = true;
  main-user.userName = "zahry";

  # SWAP
  swapDevices = [
    {
      device = "/swap";
      size = 16 * 1024; #16GB
    }
  ];

  networking.hostName = "veles";
  networking.wireless.enable = true;

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

  nixpkgs.config.allowUnfree = true;

  # Set up zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vboxusers.members = ["zahry"];
  users.extraGroups.docker.members = ["zahry"];

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages."${system}".default
    firefox

    # Dev
    pkgs.vim
    git
    gcc
    wget
    jetbrains.datagrip
    discord
    obsidian
    spotify
    slack
    vscode
    postman
  ];

  programs.git = {
    enable = true;
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11"; # Did you read the comment?

  waygang = {
    base.enable = true;

    hyprland = {
      enable = true;
      user = "zahry";
    };
  };
}
