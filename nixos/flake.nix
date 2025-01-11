{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ghostty, ... }@inputs: 
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
                inputs.home-manager.nixosModules.default
              ];
            };

            work = nixpkgs.lib.nixosSystem {
              specialArgs = {inherit inputs;};
              modules = [
                ./hosts/work/configuration.nix
                inputs.home-manager.nixosModules.default
              ];
            };
        };
    };
}
