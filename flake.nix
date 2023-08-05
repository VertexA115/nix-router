{
  description = "nix-router";

  inputs = {
    hive.follows = "nix-rebar/hive";
    nix-rebar.url = "github:VertexA115/nix-rebar";
    std.follows = "nix-rebar/std";
  };

  outputs = { self, std, nixpkgs, hive, ... }@inputs:
    hive.growOn {
      inherit inputs;

      nixpkgsConfig = { allowUnfree = true; };

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      cellsFrom = ./cells;
      cellBlocks = with std.blockTypes;
        with hive.blockTypes; [
          # Library functions
          (data "data")
          (devshells "devshells")
          (installables "packages")
          (nixago "config")
          (pkgs "overrides")
          (files "files")
          (functions "functions")
          (functions "overlays")

          # Modules
          (functions "nixosModules")

          # Profiles
          (functions "nixosProfiles")

          # Configurations
          nixosConfigurations
        ];
    }
    {
      nixosModules = hive.pick inputs.self [ "nixos" "nixosModules" ];
    };
}
