### IPTABLES ; Show current nat rules

```sh
iptables-save -t nat
```

### Example for routing wiregurad 

* add route
```sh
iptables -t nat -A POSTROUTING -s 10.66.66.0/24 -o  ens160 -j MASQUERADE
```

* remove route
```sh
iptables -t nat -D POSTROUTING -s 10.66.66.0/24 -o  ens160 -j MASQUERADE
```
