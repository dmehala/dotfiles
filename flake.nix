{
  description = "Home Manager configuration of dmehala";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs =
    { nixpkgs, home-manager, walker, ... }: {
      homeConfigurations = {
        "dmehala" = home-manager.lib.homeManagerConfiguration ({
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };

          modules = [
            walker.homeManagerModules.default
            ./home.nix
          ];
        });
      };
    };
}
