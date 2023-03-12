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

### OpenVPN

```sh
systemctl status openvpn@server

```

### Set DNS Permanently

```sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf

sudo apt update

sudo apt install resolvconf

sudo systemctl start resolvconf.service

sudo systemctl enable resolvconf.service

sudo systemctl status resolvconf.service

nano /etc/resolvconf/resolv.conf.d/head

# nameserver 8.8.8.8 
# nameserver 8.8.4.4

sudo systemctl restart resolvconf.service

sudo systemctl restart systemd-resolved.service
```

```
reboot
```



### iNFO

WIREGUARD is required to install Kernel 5.6 or above.
