{ config, pkgs, inputs, ... }:

{
  imports =
    [ 
        ./wayland/window-manager.nix # ./i3/window-manager.nix
        ./wayland/login-manager.nix
        ../../main-user.nix 
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ];


  main-user.enable = true;
  main-user.userName = "zahry";

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true; devices = ["nodev"]; efiSupport = true; useOSProber = true;
  };

  hardware.i2c.enable = true;

  # SWAP
  swapDevices = [{
    device = "/swap";
    size = 16 * 1024; #16GB
  }];

  networking.hostName = "chernobog"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "zahry" = import ./home.nix;
    };
  };

  security.polkit.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.martian-mono
    jetbrains-mono
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vboxusers.members = [ "zahry" ];
  users.extraGroups.docker.members = [ "zahry" ];


  # $ nix search wget
  environment.systemPackages = with pkgs; [
    libnotify
    rofi-wayland
    pavucontrol
    wev
    imagemagick
    brightnessctl
    imv
    libGL
    libglvnd
    wayland-utils

    # Functionality
    networkmanagerapplet
    grim
    slurp
    ripgrep
    read-edid
    kanshi
    
    # Apps
    firefox
    discord
    obsidian
    spotify
    slack
    inputs.zen-browser.packages."${system}".specific
  ];

  services.gnome.gnome-keyring.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  system.stateVersion = "23.11";
}
