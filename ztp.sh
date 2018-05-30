#!/bin/bash 
# CUMULUS-AUTOPROVISIONING
function ping_until_reachable(){
    last_code=1
    max_tries=30
    tries=0
    while [ "0" != "$last_code" ] && [ "$tries" -lt "$max_tries" ]; do
        tries=$((tries+1))
        echo "$(date) INFO: ( Attempt $tries of $max_tries ) Pinging $1 Target Until Reachable."
        ping $1 -c2 &> /dev/null
        last_code=$?
            sleep 1
    done
    if [ "$tries" -eq "$max_tries" ] && [ "$last_code" -ne "0" ]; then
        echo "$(date) ERROR: Reached maximum number of attempts to ping the target $1 ."
        exit 1
    fi
}

function init_ztp(){


# 一 license
# License the switch
cl-license -i http://192.168.0.254/cu.lic
# Set all ports on the device as admin up 
for i in `ls /sys/class/net -1 | grep swp`; do  ip link set up $i; done

# Restart switchd for license to take effect
service switchd restart



groupadd testuser
useradd testuser1 -g test -p `oenssl passwd -1 Passw0rd` -s /bin/bash

#testuser1 sudo withour password  

# Enable passwordless sudo for cumulus user
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus
# user can run net command
sed -i /etc/netd.conf -e 's/users_with_edit\ =\ root,\ cumulus/users_with_edit\ =\ root,\ cumulus,\ testuser1/g'
sed -i /etc/netd.conf -e 's/users_with_show =\ root,\ cumulus/users_with_show\ =\ root,\ cumulus,\ testuser1/g'
systemctl restart netd.service 

#add vty user
echo "username testuser1 nopassword" >> /etc/frr/vtysh.conf


 
#5.1、change the apt source 
sed -i /etc/apt/sources.list -e 's/repo3.cumulusnetworks.com\/repo/192.168.0.254/'


 


CUMULUS_TARGET_RELEASE=3.5.3
CUMULUS_CURRENT_RELEASE=$(cat /etc/lsb-release  | grep RELEASE | cut -d "=" -f2)
IMAGE_SERVER_HOSTNAME=192.168.1.1
IMAGE_SERVER=http://10.60.255.254/3.5.3.bin
ZTP_URL=http://10.60.255.254/meituanZTP.sh

if [ "$CUMULUS_TARGET_RELEASE" != "$CUMULUS_CURRENT_RELEASE" ]; then
    ping_until_reachable $IMAGE_SERVER_HOSTNAME
    /usr/cumulus/bin/onie-install -fa -i $IMAGE_SERVER -z $ZTP_URL && reboot
else
    init_ztp && reboot
fi
# CUMULUS-AUTOPROVISIONING
exit 0

 



# CUMULUS-AUTOPROVISIONING
exit 0


