# Server A

Euro location Server , it could be Debian 10 or up or Ubuntu 18.04 and up.


***

### Commands

* Step 1: Preparing VPS Server

```sh
echo "nameserver 8.8.8.8" > /etc/resolv.conf

curl -O https://raw.githubusercontent.com/ExtremeDot/golden_one/master/extremeDOT.sh && chmod +x extremeDOT.sh

mv extremeDOT.sh /bin/extremeDOT && chmod +x /bin/extremeDOT
```

* run extremeDOT Menu

```sh
extremeDOT
```

Wait untill all apps getting installed ...


***

![image](https://user-images.githubusercontent.com/120102306/224574759-21a2cebf-d463-462d-a80f-cc0d2c5be242.png)


***

* Select number 1)  System Status & Show Status and check linux Kernel. its recommended to use kernel version 5.6 or up.

![image](https://user-images.githubusercontent.com/120102306/224574943-63899fa1-f3e2-4a4d-95bb-d1ccd6617894.png)


**Install Latest XanMod Kernel**

* Select number 2)  Install XAN MOD KERNEL , then 1 to install Stable kernel

![image](https://user-images.githubusercontent.com/120102306/224575013-861f5d5a-0061-410a-a971-013fe5f10330.png)

then select option 98 to reboot.

after rebooting, run option 1 and check if Kernel has upgraded or not.

if kernel did not upgraded, run option 2 again and repeat the steps.

![image](https://user-images.githubusercontent.com/120102306/224576278-307e2939-05fc-43fa-8650-77a09550c12a.png)


***

### Installing SoftEther Server

![image](https://user-images.githubusercontent.com/120102306/224576334-f1acd632-f9c6-4459-870d-4ce0ff5b915f.png)

* Select Option 21 

` Clean SoftEther Setup? [y/n]: y `

![image](https://user-images.githubusercontent.com/120102306/224576952-8dd23850-8971-435e-b3e0-d2e2171dab8a.png)

setup will ask for data, you can leave it to default values

![image](https://user-images.githubusercontent.com/120102306/224577012-7fe765df-5272-45f2-821f-8f6520b653e3.png)


` dnsmasq.conf (Y/I/N/O/D/Z) [default=N] ? y`

![image](https://user-images.githubusercontent.com/120102306/224577128-bf0fbe3f-ab29-44f5-a9eb-5ff0751e5f53.png)

install latest stable build of softether

you can check their github for latest version , [Soft Ether Latest Stable Release GitHub Repo](https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases)

![image](https://user-images.githubusercontent.com/120102306/224578291-ce7b770d-7053-4ba3-b971-19d80e945d70.png)

Select 2

![image](https://user-images.githubusercontent.com/120102306/224578322-57ae9460-6ad6-4409-a99f-9673c96511ae.png)

Enter the ip range for Internal IP that clients get connecting to server

` 10.10.98`
you can enter everything you like x.x.x

![image](https://user-images.githubusercontent.com/120102306/224578452-eac3c8cd-d45f-4bac-99af-12c3ed14416c.png)


```sh
DHCP START IP: [Recommended = 10] 5
```

```sh
DHCP END IP: [Recommended = 35 ~ 254 ] 250
```

```sh
Install Extra Net IP forwarding configs? [y/n]: n
```

```sh
GoldenOne - First RUN Setup? [y/n]: y
```

after that, reboot server, option 98


***


### Check if softether server is running or not?

run seshow command to see user and password details created by script
```sh
seshow
```
![image](https://user-images.githubusercontent.com/120102306/224578761-1fc26ca7-5d2c-4b74-b31f-99c7f92b8603.png)

copy Password value and run command below

```sh
/usr/local/vpnserver/vpncmd
```
![image](https://user-images.githubusercontent.com/120102306/224578975-4e8954bb-e324-434b-bed3-19c5679888fc.png)

select 3

`3. Use of VPN Tools (certificate creation and Network Traffic Speed Test Tool)`

then type check command to see the softether status

```sh
VPN Tools>check
```
![image](https://user-images.githubusercontent.com/120102306/224579073-c5cb4535-1af4-4c8f-b53f-1282ee61652f.png)

after all type exit.

### check vpnserver service

```sh
service vpnserver status
```
if its not running automatically please check the crontab

***

check crontab file

```sh
crontab -e
```

it must be like that, if below lines are not included , please add them manually


```sh
@reboot /etc/init.d/vpnserver start
@reboot sleep 15 && service vpnserver start
```

***

SoftEther Server Manager 

[Download SoftEther Server Manager app from Source](https://www.softether-download.com/en.aspx)

![image](https://user-images.githubusercontent.com/120102306/224613584-4118f24a-1d8e-48be-879f-f5e9589623b9.png)

ssh to server and run seshow command to see details for connecting to server

```sh
seshow
```

![image](https://user-images.githubusercontent.com/120102306/224613845-7471342d-97e6-43a5-93b9-ab409c56a0f5.png)

copy password text

now run SoftEther VPN Server Manager

![image](https://user-images.githubusercontent.com/120102306/224614148-39ebe45b-d755-4fc2-aeab-ca9062a4e1cc.png)

click on **New Setting** then input required data.

![image](https://user-images.githubusercontent.com/120102306/224614423-e8cc6765-2a41-45b5-82f8-cc7397369751.png)

click on **OK**.

Select the Server from list then hit the **Connect **

![image](https://user-images.githubusercontent.com/120102306/224614604-5c843c4c-2c43-4b5f-bf84-19accfe57c90.png)

Yes


![image](https://user-images.githubusercontent.com/120102306/224614645-79b81a4b-726b-4e08-abe9-550f38b31595.png)


OK

![image](https://user-images.githubusercontent.com/120102306/224614835-65fa5698-ef10-4804-ba69-d07ed6030be7.png)

Select **DEFAULT** and Delete it. 

Now we have one Virtual HUB named VPN.

![image](https://user-images.githubusercontent.com/120102306/224615096-c1a3b6e2-fe8e-4d44-b404-f4c08b615357.png)

Double click on **VPN** hub and create new client and users.

`VPN HUB > Manage Users > New `

![image](https://user-images.githubusercontent.com/120102306/224615401-f2fc1e80-094a-43a3-8911-80de1bf9efb2.png)

![image](https://user-images.githubusercontent.com/120102306/224615421-881a1f3c-c812-4332-ac18-11eb58a80515.png)

![image](https://user-images.githubusercontent.com/120102306/224615436-2277beea-fd60-4999-a31c-256e486cb78a.png)





