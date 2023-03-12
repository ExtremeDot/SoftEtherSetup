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
iptables-save -t nat
```

### DNSMASQ

```sh
nano /etc/dnsmasq.conf
```
```sh
/etc/init.d/dnsmasq restart
```



