{ root, inputs, cell, ... }: let
  inherit (inputs.nixpkgs) lib;
in v: with lib; {
  options = {
    addrs = {
      primary = mkOption {
        type = with types; nullOr (submodule (addrOpts v));
        default = null;
        description = "Routable IPv${toString v} address of this machine that will be assigned to the dummy0 interface.";
      };

      anycast = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "Anycast IPv${toString v} addresses of this machine that will be assigned to the dummy0 interface.";
      };
    };

    default = mkOption {
      type = types.nullOr types.str;
      default = let n = config.networking; in if (v == 6)
      then defaultAttrs n.defaultGateway6 null (x: x.address)
      else defaultAttrs n.defaultGateway null (x: x.address);
      description = "Gateway for the IPv${toString v} default route. Defaults to the system default gateway.";
    };

    networks = mkOption {
      type = with types; listOf (submodule (addrOpts v));
      default = [ ];
      description = "List of IPv${toString v} networks that are our own. These will be unreachable by default.";
    };

    routes = {
      igp = mkOption {
        type = with types; listOf (submodule (routeOpts v));
        default = [ ];
        description = ''
          List of IPv${toString v} static routes, which will be exported to IGP peers.
        '';
      };

      egp = mkOption {
        type = with types; listOf (submodule (routeOpts v));
        default = [ ];
        description = ''
          List of IPv${toString v} static routes, which will be exported to EGP peers.
        '';
      };

      static = mkOption {
        type = with types; listOf (submodule (routeOpts v));
        default = [ ];
        description = ''
          List of IPv${toString v} static routes, which will go directly into the FIB.
        '';
      };
    };
  };
}
