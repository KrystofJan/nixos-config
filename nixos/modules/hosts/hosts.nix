{pkgs, ...}:
{
    networking.hosts = {
      "10.0.0.138" = [ "router.home.local" ];
    };
    services.bind = {
  enable = true;
  zones = {
    "home.local" = {
      master = true;
      file = pkgs.writeText "zone-home.local" ''
        $ORIGIN home.local.
        $TTL    1h
        @       IN      SOA     ns1.home.local. hostmaster.home.local. (
                                1        ; Serial
                                3h       ; Refresh
                                1h       ; Retry
                                1w       ; Expire
                                1h )     ; Negative Cache TTL
                IN      NS      ns1.home.local.
        ns1     IN      A       127.0.0.1
        router  IN      A       10.0.0.138
      '';
    };
  };
};

}
