{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options = {
    stupid.enable = lib.mkEnableOption "Enable schewpid sheight";
  };

  config = lib.mkIf config.stupid.enable {
    environment.systemPackages = with pkgs; [
      sl
      asciiquarium-transparent
    ];
  };
}
