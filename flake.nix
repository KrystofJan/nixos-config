{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    mangowc,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/perun/configuration.nix
          mangowc.nixosModules.mango
        ];
      };

      perun = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/perun/configuration.nix
          mangowc.nixosModules.mango
        ];
      };

      veles = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/veles/configuration.nix
        ];
      };

      radegast = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/radegast/configuration.nix
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.nixd
        pkgs.alejandra
      ];

      shellHook = ''
        echo "  Nix development flake   "
        echo "Starting zsh, to exit you'll need to exit zsh first and then bash  "
        echo " Let's nix it up  "
        zsh
      '';
    };
  };
}
