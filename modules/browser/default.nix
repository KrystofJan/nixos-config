{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./zen.nix
    ./firefox.nix
  ];
  options.browser = {
    zen = {
      enable = lib.mkEnableOption "Toggle zen browser";
    };
    firefox = {
      enable = lib.mkEnableOption "Toggle firefox browser";
    };
  };
}
