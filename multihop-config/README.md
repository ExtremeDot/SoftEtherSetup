### Setup MultiHop

* Domestic Server

**  WireGuard [10.66.66.1] -> DOMESTIC VPS -> CASCADE -> EURO VPS [10.10.129.1] **

```sh
ip addr add 10.10.129.42/24 brd + dev tap_soft
```

```sh
echo 1000 vpn >> /etc/iproute2/rt_tables
```

```sh
ip rule add from 10.66.66.0/24 lookup vpn
```

```sh
ip route add default via 10.10.129.1 dev tap_soft proto static table vpn
```

