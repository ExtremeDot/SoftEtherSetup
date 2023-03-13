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



