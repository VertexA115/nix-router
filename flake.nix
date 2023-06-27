{
  description = "nix-router";

  inputs = {
    std.url = "github:divnix/std";
  };

  outputs = { self, std, nixpkgs, std, ... }@inputs:
    std.growOn {
      inherit inputs;

      nixpkgsConfig = { allowUnfree = true; };

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      cellsFrom = ./cells;
      cellBlocks = with std.blockTypes; [
        (functions "nixosModules")
        (functions "nixosProfiles")

        (data "data")
        (devshells "devshells")
        (installables "packages")
        (pkgs "overrides")
        (files "files")
        (functions "overlays")
      ];
    }
    {
      nixosModules = hive.pick inputs.self [ "nixos" "nixosModules" ];
    }
}
