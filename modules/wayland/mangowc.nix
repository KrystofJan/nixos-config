{pkgs, ...}: {
  programs.mango.enable = true;

  environment.systemPackages = with pkgs; [
    foot
    wmenu
    swaybg
    hyprlock
  ];

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          user = "zahry";
          command = "mango";
        };
        default_session = initial_session;
      };
    };
  };
}
