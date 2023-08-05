# nix-router

nix-router is a router configuration framework written entirely in Nix which can dynamically generate and integrate configuration for routing tools available on NixOS, such as bird2, tinc, wireguard, tailscale, tayga, and iptables.

## Example

Make sure you import your peer configurations!
```nix
services.nix-router.router.peers = import ./peers.nix;
```

```nix
services.nix-router = {
  # enables the routing framework
  enable = true;

  # the interface to use for management and tunnel traffic
  underlay = "ens18";

  router = {
    # Configures the primary IPv4 and IPv6 addresses of this node.
    ipv4.addrs.primary = { address = "185.167.182.4"; prefixLength = 30; };
    ipv6.addrs.primary = { address = "2a10:4a80:3::1"; prefixLength = 48; };
  };

  peers = {
    ifog = {
      asn = 34927;
      types = peerTypes.upstream;
      ipv4.addrs = ["193.148.249.1"];
      ipv6.addrs = ["2a0c:9a40:1::1"];
    };
  };
}
```
