# OPENVPN File modification

RUN Soft Ether VPN Server Manager

Select OpenVPN / MS-SSTP Settings

![image](https://user-images.githubusercontent.com/120102306/225905168-c096af7a-9063-44f0-a317-a3dd8c14252c.png)


***

Add Custom Ports to make backup when the port number is blocked

![image](https://user-images.githubusercontent.com/120102306/225905358-46241d10-e9a9-4070-9d53-600659188b43.png)


Click on Generate a Sample Configuration File for OpenVPN Clients

![image](https://user-images.githubusercontent.com/120102306/225905502-d560c400-3b3c-4f50-b06b-7bd37476508e.png)


Save file , Open the file 

**ubuntu_openvpn_remote_access_l3.ovpn**

Remove All Comments , lines started with **#** and **;**


![image](https://user-images.githubusercontent.com/120102306/225906543-55e7cd53-fd14-4516-9bcd-b9db98802312.png)


```sh
dev tun
proto udp
remote 127.0.0.1 1194
cipher AES-128-CBC
auth SHA1
resolv-retry infinite
nobind
persist-key
persist-tun
client
verb 3
auth-user-pass

<ca>
-----BEGIN CERTIFICATE-----
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
-----END CERTIFICATE-----

</ca>
```

***


Now we are editing the file if we have problem to connect

Select one method

```sh
proto udp 
proto tcp
```

add all ports you enabled


```sh
remote 127.0.0.1 1194
remote 127.0.0.1 2096
remote 127.0.0.1 1010
remote 127.0.0.1 8443
remote 127.0.0.1 35179
```

***

### Sample File

```sh
client
dev tun
proto udp
remote 100.100.100.100 1010
remote 100.100.100.100 1194
remote 100.100.100.100 2096
remote 100.100.100.100 8443
remote 100.100.100.100 35179
cipher AES-128-CBC
data-ciphers AES-128-CBC
auth SHA1
auth-nocache
auth-user-pass
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
verb 3
dhcp-option DNS 94.140.14.14
ignore-unknown-option block-outside-dns
setenv opt block-outside-dns # Prevent Windows 10 DNS leak

<ca>
-----BEGIN CERTIFICATE-----

YOUR CERT CODE

-----END CERTIFICATE-----

</ca>


```
