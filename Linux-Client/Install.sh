#!/bin/bash
# Softether VPN Bridge with dnsmasq for Ubuntu
# Reference and credits:
# - https://github.com/angristan/
# - https://www.digitalocean.com/
# - https://gist.github.com/abegodong/
# - https://whattheserver.com/


function isRoot() {
        if [ "$EUID" -ne 0 ]; then
                return 1
        fi
}

if ! isRoot; then
        echo "Sorry, you need to run this as root"
        exit 1
fi

clear
ufw disable
TARGET="/usr/local/"
mkdir -p $TARGET

# Save current DNS resolv config
echo " CURRNET DNS LIST"
if grep -q "127.0.0.53" "/etc/resolv.conf"; then
                        RESOLVCONF='/run/systemd/resolve/resolv.conf'
                else
                        RESOLVCONF='/etc/resolv.conf'
fi
echo " $RESOLVCONF "
# temporary changing dns to pUBLIC GOOGLE DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
sleep 3
#/etc/init.d/networking restart # restart networks to apply changes
systemctl restart systemd-networkd
sleep 3

echo " update the linux to latest, wait for finish"
apt install --fix-broken
apt-get update
apt-get -y upgrade
clear

echo " INSTALLING PRE-REQ APPS"
apt-get -y install build-essential
apt-get -y install net-tools
apt-get -y install cmake gcc g++ make rpm pkg-config libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev
sleep 2
apt-get -y install expect && sleep 2
clear

echo
SERVER_IP=$(ip -4 addr | sed -ne 's|^.* inet \([^/]*\)/.* scope global.*$|\1|p' | head -1)
if [[ -z $SERVER_IP ]]; then
# Detect public IPv6 address
SERVER_IP=$(ip -6 addr | sed -ne 's|^.* inet6 \([^/]*\)/.* scope global.*$|\1|p' | head -1)
fi
APPROVE_IP=${APPROVE_IP:-n}
if [[ $APPROVE_IP =~ n ]]; then
read -rp "IP address: " -e -i "$SERVER_IP" IP
fi

echo
USER=`echo -e $(openssl rand -hex 1)"admin"$(openssl rand -hex 4)`
read -e -i "$USER" -p "Please enter your username: " input
USER="${input:-$USER}"

echo
SERVER_PASSWORD=`echo -e $(openssl rand -hex 1)"PAsS"$(openssl rand -hex 4)`
read -e -i "$SERVER_PASSWORD" -p "Please Set VPN Password: " input
SERVER_PASSWORD="${input:-$SERVER_PASSWORD}"
echo
SHARED_KEY=`shuf -i 12345678-99999999 -n 1`
read -e -i "$SHARED_KEY" -p "Set IPSec Shared Keys: " input
SHARED_KEY="${input:-$SHARED_KEY}"
clear
echo "=================================="
echo "IP: $SERVER_IP"
echo "USER: $USER"
echo "PASSWORD: $SERVER_PASSWORD"
echo "IP_SEC: $SHARED_KEY"
echo "=================================="
sleep 2

# get data to changing DNS Settings
echo "`sed -ne 's/^nameserver[[:space:]]\+\([^[:space:]]\+\).*$/\1/p' $RESOLVCONF`"
echo ""
        echo "What DNS resolvers do you want to use with the VPN?"
        echo "   1) Cloudflare (Anycast: worldwide)"
        echo "   2) Quad9 (Anycast: worldwide)"
        echo "   3) Quad9 uncensored (Anycast: worldwide)"
        echo "   4) FDN (France)"
        echo "   5) DNS.WATCH (Germany)"
        echo "   6) OpenDNS (Anycast: worldwide)"
        echo "   7) Google (Anycast: worldwide)"
        echo "   8) Yandex Basic (Russia)"
        echo "   9) AdGuard DNS (Anycast: worldwide)"
        echo "   10) NextDNS (Anycast: worldwide)"
        echo "   11) SKIP, No change"
	echo "   12) Custom"
        until [[ $DNS =~ ^[0-9]+$ ]] && [ "$DNS" -ge 1 ] && [ "$DNS" -le 12 ]; do
                read -rp "DNS [1-12]: " -e -i 1 DNS
                
                if [[ $DNS == "12" ]]; then
                        until [[ $DNS1 =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; do
                                read -rp "Primary DNS: " -e DNS1
                        done
                        until [[ $DNS2 =~ ^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]]; do
                                read -rp "Secondary DNS (optional): " -e DNS2
                                if [[ $DNS2 == "" ]]; then
                                        break
                                fi
                        done
                fi
        done
 
SEDIR=/ExtremeDOT/SE_latest
mkdir -p $SEDIR
sleep 2
cd $SEDIR
clear
echo
echo "always check the GitHUB for latest releases"
echo "https://github.com/SoftEtherVPN/SoftEtherVPN_Stable"
echo
echo "https://www.softether-download.com/en.aspx"
echo
echo " If you want to install another version, replace your link to the current one!"
echo " The Current Selected Version IS: v4.41-9787-beta [Release Date: 2023-03-14]"
echo "=================================="
echo
DLLINK=https://www.softether-download.com/files/softether/v4.41-9787-rtm-2023.03.14-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-v4.41-9787-rtm-2023.03.14-linux-x64-64bit.tar.gz
DLFILE=$SEDIR/Soft.tar.gz
read -e -i "$DLLINK" -p "SoftEther Link: " input
DLLINK="${input:-$DLLINK}"
curl -L $DLLINK --output $DLFILE
sleep 2
if [ -f "$DLFILE" ];
  then
    echo "Installation files are downloaded."
    tar xzvf $DLFILE -C $TARGET
    sleep 2
    rm -rf softether-vpnserver-v*
    sleep 2
  else
    echo "Installation files are not downloaded, EXIT "
    sleep 5
    echo " check Network and Source files and retry again."
    exit 0
fi

# INSTALLING SOFTETHER
cd ${TARGET}vpnserver
expect -c 'spawn make; expect number:; send 1\r; expect number:; send 1\r; expect number:; send 1\r; interact'
find ${TARGET}vpnserver -type f -print0 | xargs -0 chmod 600
chmod 700 ${TARGET}vpnserver/vpnserver ${TARGET}vpnserver/vpncmd
mkdir -p /var/lock/subsys
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/ipv4_forwarding.conf
sysctl --system

## DNS CHANGER
# DNS resolvers
DEST_RESOLV=$RESOLVCONF
case $DNS in
        
        1) # Cloudflare
                echo 'nameserver 1.0.0.1' > $DEST_RESOLV
                echo 'nameserver 1.1.1.1' >> $DEST_RESOLV
		DNSMSQ_SERV=1.1.1.1
		DNSMSQ_SERV2=1.0.0.1
                ;;
        2) # Quad9
                echo 'nameserver 9.9.9.9' > $DEST_RESOLV
                echo 'nameserver 149.112.112.112' >> $DEST_RESOLV
		DNSMSQ_SERV=9.9.9.9
		DNSMSQ_SERV2=149.112.112.112
                ;;
        3) # Quad9 uncensored
                echo 'nameserver 9.9.9.10' > $DEST_RESOLV
                echo 'nameserver 149.112.112.10' >> $DEST_RESOLV
		DNSMSQ_SERV=9.9.9.10
		DNSMSQ_SERV2=149.112.112.10
                ;;
        4) # FDN
                echo 'nameserver 80.67.169.40' > $DEST_RESOLV
                echo 'nameserver 80.67.169.12' >> $DEST_RESOLV
		DNSMSQ_SERV=80.67.169.40
		DNSMSQ_SERV2=80.67.169.12
                ;;
        5) # DNS.WATCH
                echo 'nameserver 84.200.69.80' > $DEST_RESOLV
                echo 'nameserver 84.200.70.40' >> $DEST_RESOLV
		DNSMSQ_SERV=84.200.69.80
		DNSMSQ_SERV2=84.200.70.40
                ;;
        6) # OpenDNS
                echo 'nameserver 208.67.222.222' > $DEST_RESOLV
                echo 'nameserver 208.67.220.220' >> $DEST_RESOLV
		DNSMSQ_SERV=208.67.222.222
		DNSMSQ_SERV2=208.67.220.220
                ;;
        7) # Google
                echo 'nameserver 8.8.8.8' > $DEST_RESOLV
                echo 'nameserver 8.8.4.4' >> $DEST_RESOLV
		DNSMSQ_SERV=8.8.8.8
		DNSMSQ_SERV2=8.8.4.4
                ;;
	8) # Yandex Basic
                echo 'nameserver 77.88.8.8' > $DEST_RESOLV
                echo 'nameserver 77.88.8.1' >> $DEST_RESOLV
		DNSMSQ_SERV=77.88.8.8
		DNSMSQ_SERV2=77.88.8.1
                ;;
        9) # AdGuard DNS
                echo 'nameserver 94.140.14.14' > $DEST_RESOLV
                echo 'nameserver 94.140.15.15' >> $DEST_RESOLV
		DNSMSQ_SERV=94.140.14.14
		DNSMSQ_SERV2=94.140.15.15
                ;;
        10) # NextDNS
                echo 'nameserver 45.90.28.167' > $DEST_RESOLV
                echo 'nameserver 45.90.30.167' >> $DEST_RESOLV
		DNSMSQ_SERV=45.90.28.167
		DNSMSQ_SERV2=45.90.30.167
                ;;
	11) # NO CHNAGE
        	DNSMSQ_SERV=8.8.8.8
		DNSMSQ_SERV2=8.8.4.4        
                ;;
        12) # Custom DNS
                echo "nameserver $DNS1" > $DEST_RESOLV
		DNSMSQ_SERV=$DNS1
		DNSMSQ_SERV2=8.8.8.8
                if [[ $DNS2 != "" ]]; then
                        echo "nameserver $DNS2" >> $DEST_RESOLV
			DNSMSQ_SERV2=$DNS2
                fi
                ;;
        esac
sleep 1
/etc/init.d/networking restart # restart networks to apply changes
sleep 3

# SOFTETHER SETUP

echo "Setup SoftEther Server"
HUB="VPN"
HUB_PASSWORD=${SERVER_PASSWORD}
USER_PASSWORD=${SERVER_PASSWORD}
cd ${TARGET}vpnserver

###

VPNNETWORK_IP=${VPNNETWORK_IP:-n}
if [[ $VPNNETWORK_IP =~ n ]]; then
read -rp "IP address: " -e -i "10.10.129.129" IP
fi

echo
LOCALBRIDGENAME=tap_soft
read -e -i "$LOCALBRIDGENAME" -p "Enter Local Bridge Name: " input
LOCALBRIDGENAME="${input:-$LOCALBRIDGENAME}"

# $VPNNETWORK_IP
# $LOCALBRIDGENAME
# LOCALIP=10.10.9
# UPDATE vpnserver running mode to local bridge

cat <<EOF > /etc/init.d/vpnserver
#!/bin/sh
# chkconfig: 2345 99 01
# description: SoftEther VPN Server
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
SERVER_NIC=\$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)
IPTABLESBIN=/usr/sbin/iptables
TAP_INTERFACE=$LOCALBRIDGENAME
TAP_ADDR=$(echo "$VPNNETWORK_IP" | cut -d"." -f1-3)".1"
TAP_NETWORK=$(echo "$VPNNETWORK_IP" | cut -d"." -f1-3)".0/24"
SERVER_IP=$SERVER_IP

test -x \$DAEMON || exit 0
case "\$1" in

start)
\$DAEMON start
touch \$LOCK
sleep 1
/sbin/ifconfig \$TAP_INTERFACE \$TAP_ADDR
sleep 3
;;

stop)
\$DAEMON stop
rm \$LOCK
;;

restart)
\$DAEMON stop
\$DAEMON start
sleep 1
/sbin/ifconfig \$TAP_INTERFACE \$TAP_ADDR
;;

*)
echo "Usage: \$0 {start|stop|restart}"
exit 1
esac
exit 0

EOF

echo "DNSStubListener=no" >> /etc/systemd/resolved.conf

## FOR WRONG INPUT
else
echo "vpnserver file is not configured and exit"
exit
fi
done

sysctl -f
sysctl --system
mkdir -p /var/lock/subsys
chmod 755 /etc/init.d/vpnserver
/etc/init.d/vpnserver start
update-rc.d vpnserver defaults

echo "SERVER PASSWORD= $SERVER_PASSWORD"
${TARGET}vpnserver/vpncmd localhost /SERVER /CMD ServerPasswordSet ${SERVER_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD HubCreate ${HUB} /PASSWORD:${HUB_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /HUB:${HUB} /CMD UserCreate ${USER} /GROUP:none /REALNAME:none /NOTE:none
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /HUB:${HUB} /CMD UserPasswordSet ${USER} /PASSWORD:${USER_PASSWORD}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD IPsecEnable /L2TP:yes /L2TPRAW:yes /ETHERIP:yes /PSK:${SHARED_KEY} /DEFAULTHUB:${HUB}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD BridgeCreate ${HUB} /DEVICE:soft /TAP:yes
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD ServerCipherSet AES128-SHA256
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD ServerCertRegenerate ${SERVER_IP}
${TARGET}vpnserver/vpncmd localhost /SERVER /PASSWORD:${SERVER_PASSWORD} /CMD VpnOverIcmpDnsEnable /ICMP:yes /DNS:yes

touch /bin/seshow
cat <<EOF > /bin/seshow
clear
echo "SoftEther - GoldenOne Script Data"
echo "IP:       $SERVER_IP"
echo "USER:     $USER"
echo "PASSWORD: $SERVER_PASSWORD"
echo "IP_SEC:   $SHARED_KEY"

EOF

chmod +x /bin/seshow
echo "to Show Login Information, run "seshow" command."
echo "IP: $SERVER_IP"
echo "USER: $USER"
echo "PASSWORD: $SERVER_PASSWORD"
echo "IP_SEC: $SHARED_KEY"

echo "to Show Login Information, run "seshow" command."
# CRONTAB 
crontab -l | { cat; echo "@reboot /etc/init.d/vpnserver start" ; } | crontab -
