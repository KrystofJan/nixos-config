{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in 
    {
        nixosConfigurations = {
            default = nixpkgs.lib.nixosSystem {
              specialArgs = {inherit inputs;};
              modules = [
                ./hosts/default/configuration.nix
              ];
            };

            work = nixpkgs.lib.nixosSystem {
              specialArgs = {inherit inputs;};
              modules = [
                ./hosts/work/configuration.nix
              ];
            };

            veles = nixpkgs.lib.nixosSystem {
              specialArgs = {inherit inputs;};
              modules = [
                ./hosts/veles/configuration.nix
              ];
            };
        };
    };
}
