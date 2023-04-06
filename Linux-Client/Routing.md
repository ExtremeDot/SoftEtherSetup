```sh
curl -O https://raw.githubusercontent.com/ExtremeDot/ubuntu-dhcp-server/master/dhcp-server-dot.sh && chmod +x dhcp-server-dot.sh

./dhcp-server-dot.sh
```

![image](https://user-images.githubusercontent.com/120102306/230456639-cb3c124b-b72a-46ca-a99e-c6fa5b7cd838.png)


my ip for ens33 was 192.168.2.132

![image](https://user-images.githubusercontent.com/120102306/230457113-24cd38de-5a96-41b9-a11c-a33c95d5bb82.png)


Wan Interface = ens33

select one vpn server, we will configure it later


***

```
nano /etc/netplan/88-extremedot.yaml
```

***
our interfaces were

ens33

ens35

ens36

ens37


***

Define new 88-extermedot file as below

```
network:
 version: 2
 renderer: networkd

 ethernets:

# WAN INTERFACE
  ens33:
   addresses:
    - 192.168.2.132/24
   dhcp4: no
   routes:
    - to: 0.0.0.0/0
      via: 192.168.2.1
# LAN1 INTERFACE
  ens35:
   dhcp4: no
   optional: true
   addresses:
   - 172.162.101.1/24
# LAN2 INTERFACE
  ens36:
   dhcp4: no
   optional: true
   addresses:
   - 172.162.102.1/24
# LAN3 INTERFACE
  ens37:
   dhcp4: no
   optional: true
   addresses:
   - 172.162.103.1/24

# BRIDGE
 bridges:
  bridge1:
   dhcp4: no
   optional: true
   addresses:
   - 10.1.10.1/24
   interfaces:
   - ens35
  bridge2:
   dhcp4: no
   optional: true
   addresses:
   - 10.2.10.1/24
   interfaces:
   - ens36
  bridge3:
   dhcp4: no
   optional: true
   addresses:
   - 10.3.10.1/24
   interfaces:
   - ens37
   ```
   
   ```
   netplan apply
   ```
   
   ***
   
   Now we have 
   
   1 WAN , ens33

![image](https://user-images.githubusercontent.com/120102306/230458706-4a7b175c-f0a9-4f05-887a-606da5f51684.png)

***

   3 LANs , ens35, ens36 and ens37

![image](https://user-images.githubusercontent.com/120102306/230458588-6e9a32f6-98f4-40dc-b521-e6300c3b6f66.png)


***   
   ![image](https://user-images.githubusercontent.com/120102306/230458505-20d2b9f6-b3e8-4133-a303-9fa98ca160ae.png)


   3 Bridges : bridge1, bridge2, bridge3
   
***   

![image](https://user-images.githubusercontent.com/120102306/230459108-75446731-a5bb-4401-b9d6-535c1109ea9f.png)

3 VPN Connections , tap_soft1 , tap_soft2 and tap_soft3

***

# DHCP Server Config

![image](https://user-images.githubusercontent.com/120102306/230460565-746dc68c-6d71-49a5-a49c-011ec2ea9d1a.png)


```
nano /etc/dhcp/dhcpd.conf

```

edit as below

```
subnet 10.1.10.0 netmask 255.255.255.0 {
  range 10.1.10.2 10.1.10.32;
  option domain-name-servers 10.1.10.1,1.1.1.1,1.0.0.1;
  option domain-name home;
  option subnet-mask 255.255.255.0;
  option routers 10.1.10.1;
  option broadcast-address 10.1.10.255;
  default-lease-time 3600;
  max-lease-time 7200;
}

subnet 10.2.10.0 netmask 255.255.255.0 {
  range 10.2.10.2 10.2.10.32;
  option domain-name-servers 10.2.10.1,1.1.1.1,1.0.0.1;
  option domain-name home;
  option subnet-mask 255.255.255.0;
  option routers 10.2.10.1;
  option broadcast-address 10.2.10.255;
  default-lease-time 3600;
  max-lease-time 7200;
}

subnet 10.1.10.0 netmask 255.255.255.0 {
  range 10.3.10.2 10.3.10.32;
  option domain-name-servers 10.3.10.1,1.1.1.1,1.0.0.1;
  option domain-name home;
  option subnet-mask 255.255.255.0;
  option routers 10.3.10.1;
  option broadcast-address 10.3.10.255;
  default-lease-time 3600;
  max-lease-time 7200;
}
```

```
reboot
```



***

### ROUTING PART and Making Tables


```
nano /etc/dhcp/dhcpd.conf
```

```
subnet 10.1.10.0 netmask 255.255.255.0 {
  range 10.1.10.2 10.1.10.32;
  option domain-name-servers 10.1.10.1,1.1.1.1,1.0.0.1;
  option domain-name home;
  option subnet-mask 255.255.255.0;
  option routers 10.1.10.1;
  option broadcast-address 10.1.10.255;
  default-lease-time 3600;
  max-lease-time 7200;
}

subnet 10.2.10.0 netmask 255.255.255.0 {
  range 10.2.10.2 10.2.10.32;
  option domain-name-servers 10.2.10.1,1.1.1.1,1.0.0.1;
  option domain-name home;
  option subnet-mask 255.255.255.0;
  option routers 10.2.10.1;
  option broadcast-address 10.2.10.255;
  default-lease-time 3600;
  max-lease-time 7200;
}

subnet 10.3.10.0 netmask 255.255.255.0 {
  range 10.3.10.2 10.3.10.32;
  option domain-name-servers 10.3.10.1,1.1.1.1,1.0.0.1;
  option domain-name home;
  option subnet-mask 255.255.255.0;
  option routers 10.3.10.1;
  option broadcast-address 10.3.10.255;
  default-lease-time 3600;
  max-lease-time 7200;
}
```

***

```
nano /etc/default/isc-dhcp-server
```

```
INTERFACESv4="bridge1 bridge2 bridge3"
INTERFACESv6="bridge1 bridge2 bridge3"
```

***
```
service isc-dhcp-server restart
```

***

```
nano /etc/netplan/88-extremedot.yaml
```

```
network:
 version: 2
 renderer: networkd

 ethernets:

# WAN INTERFACE
  ens33:
   addresses:
    - 192.168.2.132/24
   dhcp4: no
   routes:
    - to: 0.0.0.0/0
      via: 192.168.2.1
# LAN1 INTERFACE
  ens35:
   dhcp4: no
   optional: true
# LAN2 INTERFACE
  ens36:
   dhcp4: no
   optional: true
# LAN3 INTERFACE
  ens37:
   dhcp4: no
   optional: true

# BRIDGE
 bridges:
  bridge1:
   dhcp4: no
   optional: true
   addresses:
   - 10.1.10.1/24
   interfaces:
   - ens35
  bridge2:
   dhcp4: no
   optional: true
   addresses:
   - 10.2.10.1/24
   interfaces:
   - ens36
  bridge3:
   dhcp4: no
   optional: true
   addresses:
   - 10.3.10.1/24
   interfaces:
   - ens37
```
