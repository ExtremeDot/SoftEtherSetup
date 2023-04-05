### Previuos Steps:

[Server A - EURO LOCATION ](https://github.com/ExtremeDot/SoftEtherSetup/tree/main/multiHop-fullSetup/ServerEURO%20A)

[Server B - IRAN Location - Cascaded Into Server A](https://github.com/ExtremeDot/SoftEtherSetup/tree/main/multiHop-fullSetup/ServerIRAN%20-%20B)


***

in this tutorial we run WireGuard VPN Server on Server B [ IRAN ] and route the traffics into Server A [ Euro ] using Cascade Option on SoftEther

**WireGuard Clients -> Server B [IRAN] -> Server A [EURO]**


***

Run Commands Below:

```sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf

curl -O https://raw.githubusercontent.com/ExtremeDot/golden_one/master/extremeDOT.sh && chmod +x extremeDOT.sh

mv extremeDOT.sh /bin/extremeDOT && chmod +x /bin/extremeDOT
```


***

### Install WireGuard VPN Server

```sh
extremeDOT
```

`72) Install ANGRISTAN WIREGUARD SERVER`

Select 72

All values are automated, dont change the values otherwise you are sure about that.

`IPv4 or IPv6 public address: 190.190.190.190`

190.190.190.190 is automated and its your VPS Public IP. don't change the value.

`Public interface: eth0`

eth0 is your main WAN interface, some VPS are using ensxxx setups.

`WireGuard interface name: wg0`

`Server WireGuard IPv4: 10.66.66.1`

`Server WireGuard IPv6: fd42:42:42::1`

`Server WireGuard port [1-65535]: 56117`

`First DNS resolver to use for the clients: 8.8.8.8`

`Allowed IPs list for generated clients (leave default to route everything): 0.0.0.0/0,::/0`

![image](https://user-images.githubusercontent.com/120102306/224636919-5633309d-a20a-48fc-93c2-56e2c6762a53.png)

`The client name must consist of alphanumeric character(s). It may also include underscores or dashes and can't exceed 15 chars.
Client name: extremeUser
`

![image](https://user-images.githubusercontent.com/120102306/224637275-59b77658-cab2-4b2a-b7f6-0f9b68bc9e0b.png)

`Client WireGuard IPv4: 10.66.66.2`

`Client WireGuard IPv6: fd42:42:42::2`

at the End it will show the QR code and address of your config file.

`Your client config file is in /root/wg0-client-extremeUser.conf`

![image](https://user-images.githubusercontent.com/120102306/224638059-0b8d7b91-1aad-4918-a629-394355c963dd.png)



***


Install Wireguard Client on your device and import config file using conf file or scan QR code.

[WireGuard Installation Clients](https://www.wireguard.com/install/)

connect to Server using WireGuard, if you check th IP , you will see your IP is on Server B [IRAN] VPS.

now we will setup the SoftEther and Wireguard routing modification to access into Server A [EUROPE].

***

### check status

```
systemctl status wg-quick@wg0
```

***

### Routing Instruction


**Route WireGuard Into Server A**

Editing vpnserver file

```sh
echo "" > /etc/init.d/vpnserver

nano /etc/init.d/vpnserver
```

copy codes below into vpnserver file

```sh
#!/bin/sh
# chkconfig: 2345 99 01

# DATA
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver

# BINARY FILES
IPTABLESBIN=/usr/sbin/iptables
IP_BIN=/sbin/ip
TAP_INTERFACE=tap_soft
TABLE_VPN=vpn

# TAP CONFIGS
TAP_NETWORK=10.10.98.0/24
TAP_GW=10.10.98.1
TAP_STATIC=10.10.98.50/24

# WIREGUARD SAMPLE
FIRST_HOP=10.66.66.0/24

test -x $DAEMON || exit 0
case "$1" in

# START
start)
echo " Setting IP Tables"
$DAEMON start
touch $LOCK
sleep 1
$IP_BIN addr add  $TAP_STATIC brd + dev $TAP_INTERFACE
sleep 3
$IP_BIN rule add from $FIRST_HOP lookup $TABLE_VPN
sleep 1
$IP_BIN route add default via $TAP_GW dev $TAP_INTERFACE proto static table $TABLE_VPN
sleep 1
$IPTABLESBIN -t nat -A POSTROUTING -s $FIRST_HOP -o $TAP_INTERFACE -j MASQUERADE
;;

# STOP
stop)
$DAEMON stop
rm $LOCK
;;

# RESTART
restart)
$DAEMON stop
sleep 1
$DAEMON start
sleep 1
$IP_BIN addr add  $TAP_STATIC brd + dev $TAP_INTERFACE
;;

# INPUTS
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
```

Replace the values with your own configuration:

```sh
# BINARY FILES
IPTABLESBIN=/usr/sbin/iptables
IP_BIN=/sbin/ip
TAP_INTERFACE=tap_soft
TABLE_VPN=vpn
```
check IPTABLESBIN binary file

```sh
whereis iptables
```

`iptables: /sbin/iptables /etc/iptables /usr/share/iptables /usr/share/man/man8/iptables.8.gz
`

now we should change the value with exsisting iptables binary file.

```sh
IPTABLESBIN=/sbin/iptables
```

check IP_BIN

```sh
whereis ip
```

`ip: /bin/ip /sbin/ip /usr/share/man/man8/ip.8.gz /usr/share/man/man7/ip.7.gz`

its available and OK, so my new config for binary is:

```sh
# BINARY FILES
IPTABLESBIN=/sbin/iptables
IP_BIN=/sbin/ip
TAP_INTERFACE=tap_soft
TABLE_VPN=vpn
```


go for Next


TAP_INTERFACE, its the tap interface on Server B [IRAN], run ifconfig command to sure about it.

`ifconfig`

![image](https://user-images.githubusercontent.com/120102306/224640607-0599288e-3814-4dcd-b6df-fdb1e34e4ed5.png)


```sh
# TAP CONFIGS
TAP_NETWORK=10.10.98.0/24
TAP_GW=10.10.98.1
TAP_STATIC=10.10.98.50/24
```
all TAP configs are related to Server A EURO , [more details on Installation Setup on Server A](https://github.com/ExtremeDot/SoftEtherSetup/tree/main/multiHop-fullSetup/ServerEURO%20A#installing-softether-server)


TAP_NETWORK, its the network DHCP Server on Server A [EURO]

TAP_GW, the Network Gateway on Server A [EURO]

TAP_STATIC, its Static IP for Connecting ServerB on ServerA


```sh
# WIREGUARD SAMPLE
FIRST_HOP=10.66.66.0/24
```

FIRST_HOP, the network of WireGuard Server


at the End Save The File and Exit Nano.

`Ctrl + x`

create new table as **vpn**

```sh
echo 1000 vpn >> /etc/iproute2/rt_tables
```


Restart The VPN Server

```sh
/etc/init.d/vpnserver restart
```


***

run ifconfig command and check if new setting are configured correctly.

`
ifconfig
`

![image](https://user-images.githubusercontent.com/120102306/224643523-e40d6ef5-479c-441e-87cf-9bd66cfc733e.png)


***

Now Connect to WireGuard Client, check your ip location, if it will be ok, you should get ip from Server A Euro.


### Troubleshooting:

check iptables for nat routing
```sh
iptables-save -t nat
```

it must be like this

![image](https://user-images.githubusercontent.com/120102306/224652086-afd1fbb3-f32c-410e-877e-7085939d01e2.png)

```sh
ip rule | grep vpn
```

`32765:  from 10.66.66.0/24 lookup vpn`

```sh
ip route show table vpn
```

`default via 10.10.98.1 dev tap_soft proto static`

if vpn table is not running, we have to running commands manually

open `/etc/init.d/vpnserver` file using nano

```sh
nano /etc/init.d/vpnserver
```



