# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
        ./terminal/terminal.nix
        ./wayland/window-manager.nix 
        ../../main-user.nix
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
    ];

  main-user.enable = true;
  main-user.userName = "zahry";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
    # TODO: Deal with nerdfonts
    nerd-fonts.fira-code
    nerd-fonts.martian-mono
    # nerd-fonts.DroidSansMono
    # nerd-fonts.MartianMono
    jetbrains-mono
  ];

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.vboxusers.members = [ "zahry" ];
  users.extraGroups.docker.members = [ "zahry" ];


  # List packages installed in system profile. To search, run:
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
    vscode
    postman
    inputs.zen-browser.packages."${system}".specific

    # Dev
    vim 
    neovim
    git
    gcc
    wget
    curl
  ];

  services.gnome.gnome-keyring.enable = true;

    systemd.user.services.kanshi = {
        description = "kanshi daemon";
        environment = {
            WAYLAND_DISPLAY = "wayland-1";
            DISPLAY = ":0";
        };
        serviceConfig = {
            Type = "simple";
            ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi'';
        };
    };

  security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
  };

  programs.git = {
    enable = true;
  };

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
