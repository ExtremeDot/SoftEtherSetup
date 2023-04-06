تو این روش  قراره یه دونه سافت اتر روی ماشین مجازی اجرا کنیم که ازش چندتا کانکشن بگیریم و بعد کانکشن ها رو بالانس کنیم.

اینجا من قراره 3 تاکانکشن بیارم بالا و اون سه تا کانکشن رو بریج کنم توی 3 تا شبکه، بعد از اون میفرستم برا میکروتیک روتر



اول سافت اتر رو نصب میکنیم

دستور زیر رو از طریق ترمینال اجرا میکنیم


```
curl -O https://raw.githubusercontent.com/ExtremeDot/SoftEtherSetup/main/Linux-Client/Install.sh && chmod +x Install.sh

./Install.sh

```

صبر میکنیم تا برنامه های پیش نیاز نصب بشه

![image](https://user-images.githubusercontent.com/120102306/230411127-95e22db0-f4c2-425b-add5-8d5d287a6ef7.png)


بعد از اینکه همه پیش نیازا نصب میشه، سوالها رو از تون میپرسه

آدرس آی پی: برا من لوکال هست 
همه رو میتونیم بصورت پیش فرض رد کنیم با ENTER

![image](https://user-images.githubusercontent.com/120102306/230413518-c27c4e5f-222a-430a-b554-1c95bec8280f.png)

مرجله بعد برا دانلود فایل سافت انر هست، میتونید نسخه دیگه رو بذارید

![image](https://user-images.githubusercontent.com/120102306/230414045-772f0335-a2e2-482c-a62d-16e2c4964da5.png)

https://github.com/SoftEtherVPN/SoftEtherVPN_Stable
میتونید از سورس خودش چک کنید


Enter رو میزنیم تا شروع به دانلود کنه، 

اگه درست دانلود بشه، میره برا نصب و سوالات بعدی...

این آی پی باید رنجی از شبکه وی پی ان باشه

![image](https://user-images.githubusercontent.com/120102306/230417819-647fa678-f35a-4a43-9492-958d0eeb7c7b.png)


در انتها بهتون مشخصات سرور رو میده که باید از طریق Softether VPN ServerManager بهش وارد شید.


در انتها سیستم رو ریبوت میکنیم..


***

برای این سرور من 3 تا کانکشن خروجی در نظر گرفتم، یه دونه هم ورودی


اون یه دونه ورودی میشه WAN

اون سه تا خروجی میشه LAN


تنظیماتی که برا شبکه vmware گذاشتم این شکلیه

![image](https://user-images.githubusercontent.com/120102306/230421471-2ca003bd-dd1d-4cda-b833-263904e74704.png)

برا خود ماشین مجازی یا سرور لینوکسی هم اینجوری ست کردم


![image](https://user-images.githubusercontent.com/120102306/230421711-594aa8eb-6b40-46e5-9ed6-e466ed02acbc.png)


***

برای WAN که میذاریم یه رنج آی پی از خود مودم

برا مودم من رنج آی پی روی 192.168.2.0 هست


برا wan آی پی 192.168.2.25 رو ست میکنم


wan توی تنظیمان گذاشتم روی vmnet06 که همون intel هست که به مودم وصله

اولین کارت شبکه من توی لینوکس اینه

اون سه تای بعدی نقش لن رو دارن که با همدیگه براشون آی پی ست میکنیم

آی پی که سیستم از مودم گرفته 192.168.2.132 هست

با ssh بهش وصل میشم و دستورات رو وارد میکنم (کپی کردن دستورات راحت تره)



از تنظیمات netplan یه کپی میفرستیم توی بکاپ

```
mkdir -p /root/netplan_backup

cp /etc/netplan/* /root/netplan_backup/
```

چک کردن بکاپ
```
ls /root/netplan_backup/
```

پاک کردن تنظیمات شبکه روی نت پلان
```
rm -rf /etc/netplan/

```

```
mkdir -p /etc/netplan/
```

```
nano /etc/netplan/config.yaml
```

متن زیر رو کپی میکنیم ، 
```
network:
 version: 2
 renderer: networkd

 ethernets:

# WAN INTERFACE
  ens33:
   dhcp4: yes
```


دخیره و سیستم رو ریستارت میکنیم.


![image](https://user-images.githubusercontent.com/120102306/230424923-03519c9b-a9f9-4eea-abf5-b4530f55149a.png)

```
reboot
```

***

سیستم که اومد بالا با دستور زیرکارت های شبکه رو بررسی میکنیم.

```
ifconfig
```

![image](https://user-images.githubusercontent.com/120102306/230425722-fc48055a-3352-4ba0-b0e1-8dcf4590fdc8.png)



کارت های شبکه ای که داریم

```
ens33

ens35
ens36
ens37
```

ens33 گه همون WAN هست، اینترنت ورودی


ens35 ,36 ens37 هم که برا خروجی در نظر میگیریم.



***

با سرور منیجر وارد میشیم


![image](https://user-images.githubusercontent.com/120102306/230430960-d454ce2e-c742-4902-b95c-124213134ef0.png)

