**Please see previous setup on server A Euro for more details setup.**

[Server A : Europe Location - full setup guide](https://github.com/ExtremeDot/SoftEtherSetup/tree/main/multiHop-fullSetup/ServerEURO%20A)

Run commands below

```sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf

curl -O https://raw.githubusercontent.com/ExtremeDot/golden_one/master/extremeDOT.sh && chmod +x extremeDOT.sh

mv extremeDOT.sh /bin/extremeDOT && chmod +x /bin/extremeDOT
```

```sh
extremeDOT
```

Install XanMod Modified Kernel to latest version

```sh
1)  System Status & Show Status
```

***

```sh
2)  Install XAN MOD KERNEL  
```
![image](https://user-images.githubusercontent.com/120102306/224617774-49f3f811-d7f7-4544-bff4-4a428771a32e.png)

```sh
1) Stable XanMod Kernel release
```

***

```sh
22)[INSIDE IRAN]
```

`Clean SoftEther Setup? [y/n]: y`

![image](https://user-images.githubusercontent.com/120102306/224618520-ec9b5176-46ca-49e4-9fe4-14789765adc4.png)

leave the values to default, just check the IP address must be the same as your public VPS IP.

Select DNS , im prefering Google or AdGuard

![image](https://user-images.githubusercontent.com/120102306/224618796-6a3d0550-e197-431b-b486-38f2d7fba2d2.png)

`dnsmasq.conf (Y/I/N/O/D/Z) [default=N] ? y`

`SoftEther Link: https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.41-9782-beta/softether-vpnserver-v4.41-9782-beta-2022.11.17-linux-x64-64bit.tar.gz`

you can use another version of softether if you want or leave it to default

![image](https://user-images.githubusercontent.com/120102306/224619034-d9811d24-34bf-4c39-acf8-204d25ce851d.png)

Select Method 2

`Please enter IP gateway for virtual tap, example[10.10.9]: 10.10.9`

if you want to change internal local ip range, use x.x.x, 

`ex: 11.12.13`

`DHCP START IP: [Recommended = 10] 10`
Enter 10

`DHCP END IP: [Recommended = 40 ~ 254 ] 250`
Enter 250 , you can select smaller size of ip range, it depends on the number of users.

`Install Extra Net IP forwarding configs? [y/n]: n`

`GoldenOne - First RUN Setup? [y/n]: y`
if you want to use my automated first run setup instead of GUI setup on SoftEther VPN Manager app, select y to confirm or n to skip


***

now we are going to cascade this server into **Euro Server A**.

Install SoftEther VPN Manager , [download from source](https://www.softether-download.com/en.aspx)

` 24) Show Settings `

select 24 to show login details for SoftEther VPN Server manager, copy the password.

run SoftEther VPN Manager on your Windows or Mac-OS and enter login data for your Server

![image](https://user-images.githubusercontent.com/120102306/224620506-7662f7e0-cdfd-4a34-a231-05ed8c93da23.png)


![image](https://user-images.githubusercontent.com/120102306/224620554-a6e44958-fe0c-4725-bbc6-2784eebdf687.png)

hit Yes

![image](https://user-images.githubusercontent.com/120102306/224620584-9beb77ec-42af-4d06-b075-d827879fec95.png)

Select OK

![image](https://user-images.githubusercontent.com/120102306/224620663-813a2744-559b-4a9f-adfb-fa3391b0ba21.png)

Remove DEFAULT hub.

![image](https://user-images.githubusercontent.com/120102306/224620821-33a51883-3ff5-4a09-b821-cd216a2b7a71.png)

Select **VPN** hub and click on **Manage Virtual Hub**

![image](https://user-images.githubusercontent.com/120102306/224620909-106d221d-d375-4ff4-8247-a7ddf743e6a0.png)

Select **Manage Cascade Connections**

Click On **New**

![image](https://user-images.githubusercontent.com/120102306/224623555-edb07dc0-c0e2-4ec2-ac80-a0a53c052646.png)



`Setting Name: Server A Euro`

`Host Name: 190.190.190.190`

Public IP of your EURO VPS Server: 190.190.190.190 , change with your VPS host IP.

`Port Number: 443`

`Virtual Hub Name: VPN`

`User Name: extreme2023`

`Password:  exterme2024`

Username and password were defined from EuroServer , it must be valid data.

after all, click on **OK**.

New Cascade Server will be listed on **Cascade Connection on VPN** Window.

![image](https://user-images.githubusercontent.com/120102306/224622453-ecbb9ee6-3d25-4e66-b2a4-bc8629d73a39.png)

Select Server and click on **Online**.

![image](https://user-images.githubusercontent.com/120102306/224622645-2516d5be-509c-42e3-9580-e8fce413cdbe.png)


wait for connection to get established.

Server B [IRAN ] is cascaded into Server A [ EURO ]

Now all clients that connecting to Server B, they will route and guided into Server A.


***

Open SoftEther VPN Manager and click on **Edit config**

![image](https://user-images.githubusercontent.com/120102306/224670094-ac983af1-a34b-4671-b373-a39e67f6b4e2.png)

click on *Save to File**

![image](https://user-images.githubusercontent.com/120102306/224670300-9a483d5f-0736-48b8-8962-be317c9d92e8.png)

open file using notepad or any text editor


find `declare DDnsClient` value and set to disabled.

```sh
declare DDnsClient
	{
		bool Disabled true
	}
```

find `bool DisableNatTraversal` and set it to disabled

```sh
bool DisableNatTraversal
```

save the file and import into SoftEther Server Manager.

![image](https://user-images.githubusercontent.com/120102306/224671119-1e9e3ff9-add3-4bb6-b014-f971da2cc889.png)

click on **Import File and Apply** , then Select modified **vpn_server.config** file then click **Open**

![image](https://user-images.githubusercontent.com/120102306/224671334-1d37001a-c217-46c5-b9f6-fb9a59475206.png)


![image](https://user-images.githubusercontent.com/120102306/224671417-23ea6c56-e865-423c-9562-858cb2832da8.png)

click on Yes, serever will rebooted.






MultiHop Setup with Another VPN Server on Server B [ IRAN ]

