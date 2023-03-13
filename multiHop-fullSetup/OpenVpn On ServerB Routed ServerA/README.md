```sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf

curl -O https://raw.githubusercontent.com/ExtremeDot/golden_one/master/extremeDOT.sh && chmod +x extremeDOT.sh

mv extremeDOT.sh /bin/extremeDOT && chmod +x /bin/extremeDOT
```

```sh
extremeDOT
```

select option 71

`71) Install ANGRISTAN OPEN VPN SERVER `

`IP address: 190.190.190.190`

`Do you want to enable IPv6 support (NAT)? [y/n]: n`

```sh
What port do you want OpenVPN to listen to?
   1) Default: 1194
   2) Custom
   3) Random [49152-65535]
Port choice [1-3]: 3
```

```sh
What protocol do you want OpenVPN to use?
UDP is faster. Unless it is not available, you shouldn't use TCP.
   1) UDP
   2) TCP
Protocol [1-2]: 1
```

```sh
What DNS resolvers do you want to use with the VPN?
   1) Current system resolvers (from /etc/resolv.conf)
   2) Self-hosted DNS Resolver (Unbound)
   3) Cloudflare (Anycast: worldwide)
   4) Quad9 (Anycast: worldwide)
   5) Quad9 uncensored (Anycast: worldwide)
   6) FDN (France)
   7) DNS.WATCH (Germany)
   8) OpenDNS (Anycast: worldwide)
   9) Google (Anycast: worldwide)
   10) Yandex Basic (Russia)
   11) AdGuard DNS (Anycast: worldwide)
   12) NextDNS (Anycast: worldwide)
   13) Custom
DNS [1-12]: 9
```

```sh
Do you want to use compression? It is not recommended since the VORACLE attack makes use of it.
Enable compression? [y/n]: n
```

```sh
Do you want to customize encryption settings?
Unless you know what you're doing, you should stick with the default parameters provided by the script.
Note that whatever you choose, all the choices presented in the script are safe. (Unlike OpenVPN's defaults)
See https://github.com/angristan/openvpn-install#security-and-encryption to learn more.

Customize encryption settings? [y/n]: n
```

`Press any key to continue...`

![image](https://user-images.githubusercontent.com/120102306/224657081-c0893234-af8b-436d-9b4c-94c0552296a3.png)


```sh
Tell me a name for the client.
The name must consist of alphanumeric character. It may also include an underscore or a dash.
Client name: extremeAdmin
```

```sh
Do you want to protect the configuration file with a password?
(e.g. encrypt the private key with a password)
   1) Add a passwordless client
   2) Use a password for the client
Select an option [1-2]: 1
```

```sh
The configuration file has been written to /root/extremeAdmin.ovpn.
Download the .ovpn file and import it in your OpenVPN client.
Press enter to back to menu
```

![image](https://user-images.githubusercontent.com/120102306/224657732-adcd6321-0952-4c39-9ab7-e231f295504d.png)


no Using SFTP clients loginto Server and download the file:

`/root/extremeAdmin.ovpn`

put **extremeAdmin.ovpn** into openvpn client and connect to server.

***

### Routing

OpenVPN Client is connecting to Server B, if we check the ip location when connecting to OpenVPN Server, it will show the IP of Server B [IRAN]

**Now we Route OpenVPN Server into Server A [EURO]**

run **ifconfig** to see our available networks

```sh
ifconfig
```

![image](https://user-images.githubusercontent.com/120102306/224659996-743ef394-8b5a-4537-9003-e2cdac8f6745.png)

**tap_soft** and **wg0** were set before from this tuturial. [WireGuard on ServerB Routed ServerA](https://github.com/ExtremeDot/SoftEtherSetup/tree/main/multiHop-fullSetup/WireGuard%20on%20ServerB%20Routed%20ServerA)

now we will add **tun0** OpenVPN Server to VPN table created before.

```sh
ip rule add from 10.8.0.0/24 lookup vpn
```

```sh
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o tap_soft -j MASQUERADE
```

now reconnect OpenVPN client and check for new ip location, it must return the ip of Server A [EURO] IP.

if its ok, now we will add new configs into `/etc/init.d/vpnserver` file.


```sh 
nano /etc/init.d/vpnserver
```

copy below lines and add them on top of `# START` comment.

```sh
# OPENVPN SAMPLE
OVPN_HOP="10.8.0.0/24"
```
![image](https://user-images.githubusercontent.com/120102306/224662951-2881e403-6bbe-4e87-b2d6-27c2d76280be.png)

find the `$IP_BIN rule add from $FIRST_HOP lookup $TABLE_VPN` from Start) function and paste the below line on top of that.

```sh
$IP_BIN rule add from $OVPN_HOP lookup $TABLE_VPN
```

![image](https://user-images.githubusercontent.com/120102306/224663519-6270e568-0af9-4802-a064-3af4b592d439.png)


find the `$IPTABLESBIN -t nat -A POSTROUTING -s $FIRST_HOP -o $TAP_INTERFACE -j MASQUERADE` from Start) function and paste the command on top of that.

```sh
$IPTABLESBIN -t nat -A POSTROUTING -s $OVPN_HOP -o $TAP_INTERFACE -j MASQUERADE
```

![image](https://user-images.githubusercontent.com/120102306/224664338-dd6a1b1d-094a-488f-9e1b-06bf1539ee9b.png)


save the file and reboot the server.


***


Check if works fine after rebooting machine.

* check ip rule on VPN table

```sh 
ip rule | grep vpn
```

the output must be like this

```sh
32764:  from 10.66.66.0/24 lookup vpn
32765:  from 10.8.0.0/24 lookup vpn
```


* check table default routes


```sh 
ip route show table vpn
```

```sh
default via 10.10.98.1 dev tap_soft proto static
```

* check iptables nat rules

```sh
iptables-save -t nat
```

```
-A POSTROUTING -s 10.8.0.0/24 -o tap_soft -j MASQUERADE
-A POSTROUTING -s 10.66.66.0/24 -o tap_soft -j MASQUERADE
```



