{ config, pkgs, lib, ... }:
{
  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  environment.systemPackages = with pkgs; [
    (pkgs.waybar.overrideAttrs(oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))

    pkgs.dunst
    libnotify
    swww
    rofi-wayland
    starship
    alacritty
    kitty
    pavucontrol
    wev
    wl-clipboard
    imagemagick
    brightnessctl
    imv

    networkmanagerapplet
    grim
    slurp
    hyprlock
    hyprcursor
    hypridle
  ];

  xdg.portal = { 
	enable = true;
  	extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
  };

  services.greetd = {
    enable = true;
    vt = 3;

    settings = rec {
      initial_session = {
        user = "zahry";
        command = "Hyprland";
      };
      default_session = initial_session;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.martian-mono
    jetbrains-mono
  ];

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    layout = "us";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    xkbVariant = ""; 
   };
}
