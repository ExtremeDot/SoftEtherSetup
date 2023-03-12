# SoftEtherSetup

### SoftEther VPN Server
```sh
/etc/init.d/vpnserver restart
```
```sh
nano /etc/init.d/vpnserver
```

### check iptables nat 

```sh
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE  # route all clients with ip 10.8.0.x into eth0 network
```

```sh
iptables-save -t nat   # show current iptables nat
```

### Save Routing Tables Permanent
```sh
service netfilter-persistent save
```

### DNSMASQ

```sh
nano /etc/dnsmasq.conf
```
```sh
/etc/init.d/dnsmasq restart
```


