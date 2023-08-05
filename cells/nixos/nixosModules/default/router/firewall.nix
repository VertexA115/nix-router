{ root, inputs, cell, ... }:
{ self, config, lib, pkgs, ... }: let
  inherit (config.services) nixos-router;
  cfg = nixos-router.router;
in mkIf nixos-router.enable
{
  # TODO: Below peer firewall rules should be deduplicated
  # If we have more than one peer using v4/v6 hybrid we need to use this way

  # Allow IPv4 and IPv6 BGP peers to communicate with us on the BGP TCP port (179)
  services.nixos-router.firewall.input = ''
    # BGP peers
    ${concatStrings (flatten
        (forEach resolvePeers (peer:
            mapAttrsToList (n: _: ''
                iptables -A eidolon-fw -s ${n} -p tcp --dport 179 -j ACCEPT
            '') peer.neighbor.v4addrs ++
            mapAttrsToList (n: _: ''
                ip6tables -A eidolon-fw -s ${n} -p tcp --dport 179 -j ACCEPT
            '') peer.neighbor.v6addrs
    )))}
  '';
}
