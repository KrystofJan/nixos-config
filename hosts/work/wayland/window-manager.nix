{ config, pkgs, lib, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-enviroment";
    executable = true;

    text = ''
      dbus-update-activation-enviroment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure/-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsetting-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'WhiteSur-dark'
        gsettings set $gnome_schema cursor-theme 'capitaine-cursors-white'
      '';
  };

in
{
  environment.systemPackages = with pkgs; [
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    xwayland
    xdg-utils
    glib
    whitesur-icon-theme
    grim
    slurp
    wl-clipboard
    gammastep    
    geoclue2
    capitaine-cursors
    vulkan-tools
    xdg-desktop-portal
  ];

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            vpl-gpu-rt
            intel-vaapi-driver
            intel-media-driver
            libvdpau-va-gl
        ];
    };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  services.xserver = {
    enable = true;
    
    videoDrivers = ["intel"];
    layout = "us";
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    xkbVariant = ""; 
};

    environment.variables = {
        XDG_SESSION_TYPE = "wayland";
        KITTY_ENABLE_WAYLAND = "1";
        LIBGL_ALWAYS_SOFTWARE = "0";
    };

    environment.sessionVariables = {
        LIBVA_DRIVER_NAME="iHD";
    };

    services.geoclue2.enable = true;
    services.avahi = {
        enable = true;
        nssmdns = true; # Optional: if you need Avahi for name resolution.
    };

environment.etc."xdg/geoclue/geoclue.conf".text = ''
  [service-settings]
  service-timeout = 0
'';


    programs.light.enable = true;

    # systemd.user.services.kanshi = {
    #     description = "kanshi daemon";
    #     environment = {
    #         WAYLAND_DISPLAY = "wayland-1";
    #         DISPLAY = ":0";
    #     };
    #     serviceConfig = {
    #         Type = "simple";
    #         ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi'';
    #     };
    # };
      security.rtkit.enable = true;
  services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
  };

}
