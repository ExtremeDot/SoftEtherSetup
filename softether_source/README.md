### Install

```sh
curl -O https://raw.githubusercontent.com/ExtremeDot/SoftEtherSetup/main/softether_source/build_se_fromsource.sh

chmod +x build_se_fromsource.sh

./build_se_fromsource.sh

```

### Remove SoftEther

```sh

/etc/init.d/vpnserver stop

rm -r /usr/local/vpnserver/vpnserver

rm /etc/init.d/vpnserver

```
