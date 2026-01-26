{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./base.nix
    ./work.nix
    ./personal.nix
  ];

  options.essentials = {
    base = {
      enable = lib.mkEnableOption "Toggle base packages";
    };
    work = {
      enable = lib.mkEnableOption "Toggle work packages";
    };
    personal = {
      enable = lib.mkEnableOption "Toggle personal packages";
    };
  };
}
