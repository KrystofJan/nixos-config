# /etc/nixos/configuration.nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager = {xterm.enable = false;};
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };
  #services.xserver.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "in";
    xkbVariant = "eng";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  environment.systemPackages = with pkgs; [
    cmatrix
    xfce.thunar
    htop
    xfce.ristretto
    feh
    lxappearance
    zip
    jq
    unzip
    qemu_kvm
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.picom = {
    enable = true;
    fade = true;
    #    vSync = true;
    shadow = true;
    fadeDelta = 4;
    inactiveOpacity = 0.8;
    activeOpacity = 1;
    #    backend = "glx";
    settings = {
      blur = {
        #method = "dual_kawase";
        #	background = true;
        strength = 5;
      };
    };
  };
}
