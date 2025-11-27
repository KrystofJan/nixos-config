{pkgs, ...}: {
  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  environment.systemPackages = with pkgs; [
    hyprlock
    hyprcursor
    hypridle
  ];

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          user = "zahry";
          command = "Hyprland";
        };
        default_session = initial_session;
      };
    };
  };
}
