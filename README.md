# SoftEtherSetup

### SoftEther VPN Server Restart
```sh
/etc/init.d/vpnserver restart
```

###  Edit vpnserver file

```sh
nano /etc/init.d/vpnserver
```

### check iptables nat 

```sh
iptables-save -t nat
```

### Edit DNSMASQ config

```sh
nano /etc/dnsmasq.conf
```



