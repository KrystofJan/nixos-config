{
  lib,
  config,
  ...
}: {
  options = {
    docker = {
      enable = lib.mkEnableOption "Enable docker for users";

      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["alice" "bob"];
        description = "Users to add to the docker group.";
      };
    };
  };

  config = lib.mkIf config.docker.enable {
    virtualisation.docker.enable = true;
    users.extraGroups.docker.members = config.docker.users;
  };
}
