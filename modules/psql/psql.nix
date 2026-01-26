{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.postgres;
in {
  options.postgres = {
    enable = lib.mkEnableOption "Enable postgres";

    databases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["rusalka" "kratos"];
      description = "Databases you want to add";
    };
  };

  config = lib.mkIf cfg.enable {
    config.services.postgresql = {
      enable = true;
      ensureDatabases = cfg.databases;
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
    };
  };
}
