{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";
  inputs.nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-index-database.url = "github:Mic92/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-darwin.url = "github:LnL7/nix-darwin";
  inputs.nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

  # Optional: Declarative tap management
  inputs.homebrew-core = {
    url = "github:homebrew/homebrew-core";
    flake = false;
  };
  inputs.homebrew-cask = {
    url = "github:homebrew/homebrew-cask";
    flake = false;
  };
  inputs.homebrew-bundle = {
    url = "github:homebrew/homebrew-bundle";
    flake = false;
  };

  inputs.neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  inputs.neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

  outputs = inputs:
    with inputs; let

      nixpkgsWithOverlays = system: (import nixpkgs rec {
        inherit system;

        config = {
          allowUnfree = true;
        };

        overlays = [
          (_final: prev: {
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit config;
            };
          })
          neovim-nightly-overlay.overlays.default
        ];
      });

      configurationDefaults = args: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
      };

      argDefaults = {
        inherit inputs self nix-index-database;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };

      mkNixosConfiguration = {
        system ? "x86_64-linux",
        hostname,
        username,
        args ? {},
        modules,
      }: let
        specialArgs = argDefaults // {inherit hostname username;} // args;
      in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          pkgs = nixpkgsWithOverlays system;
          modules =
            [
              (configurationDefaults specialArgs)
              home-manager.nixosModules.home-manager {
                home-manager.users.${username} = import ./home.nix;
                users.users.${username}.home = "/home/${username}";
              }
            ]
            ++ modules;
        };

      mkDarwinConfiguration = {
        system ? "aarch64-darwin",
        hostname,
        username,
        args ? {},
        modules,
      }: let
        specialArgs = argDefaults // {inherit hostname username;} // args;
      in
        nix-darwin.lib.darwinSystem {
          inherit system specialArgs;
          pkgs = nixpkgsWithOverlays system;
          modules =
            [
              (configurationDefaults specialArgs)
              home-manager.darwinModules.home-manager {
                home-manager.users.${username} = import ./home.nix;
                users.users.${username}.home = "/Users/${username}";
              }
            ]
            ++ modules;
        };
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      nixosConfigurations.nixos-wsl = mkNixosConfiguration {
        hostname = "nixos-wsl";
        username = "nixos";
        modules = [
          nixos-wsl.nixosModules.wsl
          ./wsl.nix
          ./podman.nix
        ];
      };

      darwinConfigurations."Georges-MacBook-Pro" = mkDarwinConfiguration {
        hostname = "Georges-MacBook-Pro";
        username = "george";
        modules = [
          ./darwin.nix
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "george";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/cask" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = false;
            };
          }
        ];
      };
    };
}
