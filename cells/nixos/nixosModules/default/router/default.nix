{ root, inputs, cell, ... }:
{ self, config, lib, pkgs, ... }: let
  inherit (config.services) nixos-router;
  cfg = nixos-router.router;

  versionOpts = root.router.__lib.version-opts;
in
{
  imports = [
    root.default.router.firewall
    root.default.router.interfaces
  ];

  options = with lib; {
    services.nixos-router.router = {
      enable = mkEnableOption "nixos-router routing module";

      id = mkOption {
        type = types.str;
        default = cfg.ipv4.addrs.primary.address;
        description = ''
          The router ID used for i.e. OSPF.
          Added to the configuration of the routing software.
        '';
      };

      backend = mkOption {
        type = types.str;
        default = "bird";
        description = ''
          The routing backend software to use. Currently only bird is supported.
        '';
      };

      peers = mkOption {
        type = types.listOf types.attrs;
        default = [];
        description = ''
          List of peer objects this router will connect to.
          See the documentation for detailed information.
        '';
      };

      bgp = {
        asn = mkOption {
          type = types.int;
          description = ''
            The autonomous system number (ASN) of this router's network.
          '';
        };

        reflector = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to make this router a route reflector.
          '';
        };
      };

      ipv4 = mkOption {
        type = types.submodule (versionOpts 4);
        description = ''
          Configuration specific to IPv4 routing.
        '';
      };

      ipv6 = mkOption {
        type = types.submodule (versionOpts 6);
        description = ''
          Configuration specific to IPv6 routing.
        '';
      };
    };
  };
}
