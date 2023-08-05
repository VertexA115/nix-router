{ root, inputs, cell, ... }:
{ self, config, lib, pkgs, ... }:
{
  imports = [
    root.default.router.default
  ];

  options = {
    services.nixos-router = with lib; {
      enable = mkEnableOption "Router";

      underlay = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          The default interface to route tunneled traffic on.
        '';
      };
    };
  };
}
