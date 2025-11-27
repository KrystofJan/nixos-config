{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # ../../modules/hosts/hosts.nix

    ../../main-user.nix
    ../../modules/must-haves/must-haves.nix
    # ../../modules/wayland/hyprland.nix
    ../../modules/wayland/base.nix
    ../../modules/wayland/mangowc.nix
    ../../modules/bootloader/grub.nix
    ../../modules/obs/obs.nix
    # ../../modules/usb-notifications/usb-notifications.nix  # Fixed but disabled for now
    ./hardware-configuration.nix
    ./gc/gc.nix
    ./virtualization/docker.nix
    ./virtualization/virtualbox.nix
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

  # USB Automounting Configuration
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  # Enable automatic mounting of removable media
  services.devmon.enable = true;

  # Enable polkit for USB automounting
  security.polkit.enable = true;

  # Add polkit rules for USB mounting
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
            action.id == "org.freedesktop.udisks2.filesystem-mount" ||
            action.id == "org.freedesktop.udisks2.filesystem-unmount-system" ||
            action.id == "org.freedesktop.udisks2.filesystem-unmount") {
            if (subject.isInGroup("storage") || subject.isInGroup("wheel")) {
                return polkit.Result.YES;
            }
        }
    });
  '';

  # Ensure udisks2 service starts automatically
  systemd.services.udisks2 = {
    wantedBy = ["multi-user.target"];
  };

  # Add udev rules for USB device permissions
  services.udev.extraRules = ''
    # Set proper permissions for USB devices
    SUBSYSTEM=="usb", MODE="0664", GROUP="storage"
    SUBSYSTEM=="block", SUBSYSTEMS=="usb", MODE="0664", GROUP="storage"

    # Notify desktop environment about USB device changes
    SUBSYSTEM=="block", KERNEL=="sd[a-z][0-9]", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="udisks2.service"
  '';

  networking = {
    hostName = "perun";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
      };
    };
  };

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
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "jetbrains.datagrip"
        "spotify"
      ];
  };

  # Set up zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default

    # Term
    ghostty

    # Apps
    firefox
    discord
    obsidian
    spotify
    slack
    vscode
    postman
    ffmpeg
    nemo-with-extensions

    # Dev
    pkgs.vim
    git
    gcc
    gnumake
    killall
    wget

    networkmanagerapplet
    # jetbrains.datagrip
  ];

  # Enable gvfs for USB automounting in desktop environments
  services.gvfs.enable = true;

  programs.git = {
    enable = true;
  };

  system.stateVersion = "23.11";
}
