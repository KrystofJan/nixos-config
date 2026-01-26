{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../main-user.nix
    ../../modules/stupid/default.nix
    ../../modules/essentials/default.nix
    ../../modules/waygang/default.nix
    ../../modules/bootloader/bootGrub.nix
    ../../modules/obs/default.nix
    ../../modules/browser/default.nix
    ../../modules/virtualization/docker.nix
    ../../modules/virtualization/virtualbox.nix
    ./hardware-configuration.nix
  ];

  main-user.enable = true;
  main-user.userName = "zahry";

  swapDevices = [
    {
      device = "/swap";
      size = 16 * 1024; #16GB
    }
  ];

  networking = {
    hostName = "perun";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
      };
    };
  };

  time.timeZone = "Europe/Prague";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };

  system.stateVersion = "25.11";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Allow unfree packages

  environment.systemPackages = with pkgs; [
    # Term
    ghostty
  ];

  users.defaultUserShell = pkgs.zsh;

  # My modules
  bootGrub.enable = true;
  stupid.enable = true;
  docker = {
    enable = true;
    users = ["zahry"];
  };

  virtualbox = {
    enable = true;
    users = ["zahry"];
  };

  waygang = {
    base.enable = true;

    mangowc = {
      enable = true;
      user = "zahry";
    };
  };

  browser = {
    zen.enable = true;
    firefox.enable = false;
  };

  obs.enable = true;

  essentials = {
    base.enable = true;
    personal.enable = true;
    work.enable = true;
  };

  services = {
    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
    devmon.enable = true;
    gvfs.enable = true;
    udev.extraRules = ''
      # Set proper permissions for USB devices
      SUBSYSTEM=="usb", MODE="0664", GROUP="storage"
      SUBSYSTEM=="block", SUBSYSTEMS=="usb", MODE="0664", GROUP="storage"

      # Notify desktop environment about USB device changes
      SUBSYSTEM=="block", KERNEL=="sd[a-z][0-9]", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}+="udisks2.service"
    '';
  };

  security = {
    polkit = {
      enable = true;
      extraConfig = ''
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
    };
  };

  # Add polkit rules for USB mounting
  systemd.services.udisks2 = {
    wantedBy = ["multi-user.target"];
  };
}
