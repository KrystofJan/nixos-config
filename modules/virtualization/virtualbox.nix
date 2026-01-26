{
  lib,
  config,
  ...
}: {
  options = {
    virtualbox = {
      enable = lib.mkEnableOption "Enable virtualbox for users";

      users = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = ["alice" "bob"];
        description = "Users to add to the docker group.";
      };
    };
  };

  config = lib.mkIf config.virtualbox.enable {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = config.virtualbox.users;
  };
}
