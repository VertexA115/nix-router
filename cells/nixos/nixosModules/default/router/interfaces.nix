{ root, inputs, cell, ... }:
{ self, config, lib, pkgs, ... }: let
  inherit (config.services) nixos-router;
  cfg = nixos-router.router;
in mkIf nixos-router.enable
{
  networking = {
    interfaces.lo = {
      # set the dummy interface as primary, since it will be routed
      primary = true;

      # set up dummy interface addresses
      ipv4.addresses = with cfg.ipv4.addrs; (optional (primary != null) primary) ++ (addrsToOpts anycast 4);
      ipv6.addresses =
        let
          # Required for bird to pick up the interface for OSPF
          # See known issue on ML: https://bird.network.cz/pipermail/bird-users/2017-May/011240.html
          linkLocal = { address = "fe80::1"; prefixLength = 128; };
        in
        with cfg.ipv6.addrs; (optional (primary != null) primary) ++ (addrsToOpts anycast 6) ++ [ linkLocal ];
    };
  };
}
