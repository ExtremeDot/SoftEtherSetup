## this is **/etc/init.d/vpnserver** file

Secure NAT is disabled

![image](https://github.com/ExtremeDot/SoftEtherSetup/assets/120102306/1f262530-9d81-4ea5-ab6f-a79b5b546910)

---


local bridge name is **se** [tap_se]

![image](https://github.com/ExtremeDot/SoftEtherSetup/assets/120102306/3ee72492-cc4b-4577-9441-e540bc8bf181)


### need to update these vars

WireGuard Server is Running on : WG_HOP=10.66.88.0/24
OpenVPN Server is Running on   : OVPN_HOP="10.8.0.0/24"

TAP_INTERFACE=tap_se
TAP_NETWORK=10.10.129.0/24
TAP_GW=10.10.129.1
TAP_STATIC=10.10.129.65/24

IPTABLESBIN=/usr/sbin/iptables
IP_BIN=/sbin/ip
TAP_INTERFACE=tap_se
TABLE_VPN=800


***

```sh
#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
#
# WireGuard [10.66.88.1] -> DOMESTIC VPS -> CASCADE -> EURO VPS [10.10.129.1]
# OpenVPN [10.8.0.1] -> DOMESTIC VPS -> CASCADE -> EURO VPS [10.10.129.1]

# DATA
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver

# BINARY FILES
IPTABLESBIN=/usr/sbin/iptables
IP_BIN=/sbin/ip
TAP_INTERFACE=tap_se
TABLE_VPN=800

# TAP CONFIGS
TAP_NETWORK=10.10.129.0/24
TAP_GW=10.10.129.1
TAP_STATIC=10.10.129.65/24

# WIREGUARD SAMPLE
WG_HOP=10.66.88.0/24

# OPENVPN SAMPLE
OVPN_HOP="10.8.0.0/24"

test -x $DAEMON || exit 0
case "$1" in

# START
start)
echo " Setting IP Tables"
$DAEMON start
touch $LOCK
sleep 5
$IP_BIN addr add  $TAP_STATIC brd + dev $TAP_INTERFACE
sleep 3
$IP_BIN rule add from $WG_HOP lookup $TABLE_VPN
sleep 1
$IP_BIN rule add from $OVPN_HOP lookup $TABLE_VPN
sleep 1
$IP_BIN route add default via $TAP_GW dev $TAP_INTERFACE proto static table $TABLE_VPN
sleep 1
$IPTABLESBIN -t nat -A POSTROUTING -s $WG_HOP -o $TAP_INTERFACE -j MASQUERADE
sleep 1
$IPTABLESBIN -t nat -A POSTROUTING -s $OVPN_HOP -o $TAP_INTERFACE -j MASQUERADE
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

***

