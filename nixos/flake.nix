{
  description = "razen NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, dank-material-shell, ghostty, zen-browser, nix-cachyos-kernel, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.razen = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/razen/configuration.nix
          ./hosts/razen/hardware-configuration.nix

          niri.nixosModules.niri

          dank-material-shell.nixosModules.dank-material-shell
          dank-material-shell.nixosModules.greeter

          ({ pkgs, ... }: {
            nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ];
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.razen = import ./home/default.nix;
            home-manager.extraSpecialArgs = {
              inherit dank-material-shell ghostty niri zen-browser;
            };
          }
        ];
      };
    };
}
