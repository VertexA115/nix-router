{ root, inputs, cell, ... }: let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs.cells.lib) dev;
in {
  peer = with lib; let
    versionModule = v: {
      options = {
        addresses = mkOption {
          description = ''
            The IPv${toString v} addresses of this peer.
          '';
          type = types.listOf types.str;
        };

        maxPrefix = mkOption {
          description = ''
            The maximum number of prefixes to import from this peer.
          '';
          type = types.int;
        };
      };
    };
    versionOption = v: mkOption {
      type = types.submodule (versionModule v);
      description = ''
        Configuration specific to IPv${toString v} routing.
      '';
    };
  in types.submodule ({ config, ... }: {
    options = {
      asn = mkOption {
        description = ''
          The autonomous system number (ASN) of this peer.
        '';
        type = types.int;
      };

      types = mkOption {
        description = ''
          The type(s) of this peer. Determines what routes we import and export.
          See the documentation for the behaviour of each specific type.
        '';
        type = with types; listOf (enum [
          "ix"
          "peer"
          "upstream"
          "downstream"
          "internal"
        ]);
      };

      ipv4 = versionOption 4;
      ipv6 = versionOption 6;
    };
  });
}
