{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))

    pkgs.dunst
    libnotify
    swww
    rofi
    starship
    alacritty
    kitty
    ghostty
    pavucontrol
    wev
    wl-clipboard
    imagemagick
    brightnessctl
    imv

    nemo-with-extensions
    nemo

    # USB automounting support
    udisks
    udiskie

    grim
    slurp
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.martian-mono
    jetbrains-mono
  ];

  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      xkb = {
        variant = "";
        layout = "us";
      };
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
