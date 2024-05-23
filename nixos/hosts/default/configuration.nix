# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
 
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

  networking.hostName = "perun"; # Define your hostname.
  #  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    layout = "us";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    xkbVariant = "";
  };
	
  # Define a user account. Don't forget to set a password with ‘passwd’.
#  users.users.zahry = {
 #   isNormalUser = true;
  #  description = "Jan-Krystof Zahrandik";
   # extraGroups = [ "networkmanager" "wheel" ];
    #packages = with pkgs; [];
  #};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "zahry" = import ./home.nix;
    };
  };

  # Hyprland
  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;


  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "MartianMono"]; })
    jetbrains-mono
  ];

  # Set up zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    
    # DesktopEnv
    (pkgs.waybar.overrideAttrs(oldAttrs: {
    	mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
    pkgs.dunst
    libnotify
    swww
    rofi-wayland
    zsh-powerlevel10k
    alacritty
    shotman
    pavucontrol
    wev
    brightnessctl

    # Cli
    zellij
    fzf
    thefuck
    zoxide
    atuin
    eza
    bat
    btop
    neofetch

    # Functionality
    networkmanagerapplet
    shotman
    
    # Apps
    pkgs.firefox
    discord
    obsidian
    spotify
    vscode
    jetbrains.datagrip

    # Dev
    pkgs.vim 
    neovim
    git
    gcc
    cargo
    rustc
    lazygit
    gnumake
    python310
    nodejs 
    killall
    python310Packages.pip
    python310Packages.pipx
    python310Packages.numpy
    python310Packages.pyarrow
  #  wget
  ];

  xdg.portal = { 
	enable = true;
  	extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  sound.enable = true;
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
