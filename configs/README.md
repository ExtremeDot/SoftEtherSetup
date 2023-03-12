# vpnserver file , how to configure?

`IPTABLESBIN=/usr/sbin/iptables`
location of iptables command

`IFCONFIG=/sbin/ifconfig`
location of ifconfig command

`IPBIN=/sbin/ip`
location of ip command

SERVER_IP=124.124.124.124`
your VPS public ip, change it with your own server.

`SERVER_NIC=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)`
The main Network adapter name of VPS server, ex: eth0, ens160 and ...
if wrong detected , change it with your network adapter name. run ifconfig command to see the list.

for ex:
![image](https://user-images.githubusercontent.com/120102306/224542580-8629f73e-5913-4c0d-a4e3-456d23b30874.png)

`SERVER_NIC=ens160`



`TAP_INTERFACE=tap_ext`
The name of local bridge connection is created by VPN Server

`TAP_ADDR=9.9.9.1`
`TAP_NETWORK=9.9.9.0/24`

The ip settings for DHCP server using DNMASQ service

`TAP_STATIC=10.10.129.50/24`

Set the static ip when you are using multi hop setup

for example :


**SERVER A: Germany VPS**
Public IP Address :     129.140.12.19
DHCP Server :           11.11.111.0/24
DHCP_RANGE :            11.11.111.10 ~ 11.11.111.250

**SERVER B: IRAN VPS**
Public IP Address :     130.12.11.250
TAP_STATIC=11.11.111.50/24

Server B is cascaded into Server A
Server B Clients Internal IP Range = 11.11.111.10 ~ 11.11.111.250








