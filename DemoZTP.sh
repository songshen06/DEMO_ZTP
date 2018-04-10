#!/bin/bash 
# CUMULUS-AUTOPROVISIONING

# Log all output from this script

# 一 license
# 装载liencse ，license 放在http server上
# License the switch
sudo cl-license -i http://192.168.0.254/cu.lic
# 二 起端口  
# Set all ports on the device as admin up （起端口，必须有license 导入）
for i in `ls /sys/class/net -1 | grep swp`; do  ip link set up $i; done

# Restart switchd for license to take effect
sudo service switchd restart

#三添加本地san
cp /home/cumulus/.bashrc /etc/skel/ #new user will have bash complete
groupadd san 
useradd san -g san -p `openssl passwd -1 P4ssw0rd` -s /bin/bash -d /home/san
# 密码 
#用命令 echo "P4sSw0rD" | openssl passwd -1 -stdin
#生成加密字符串“$1$Jxmpx1Da$Y8MzBctIyDW8/7pFPbNWD1”

#san sudo 不输入密码

# Enable passwordless sudo for cumulus user
echo "cumulus ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10_cumulus
echo "san ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/11_san
# 有 netshow 权限
sed -i /etc/netd.conf -e 's/users_with_edit\ =\ root,\ cumulus/users_with_edit\ =\ root,\ cumulus,\ san/g'
sed -i /etc/netd.conf -e 's/users_with_show =\ root,\ cumulus/users_with_show\ =\ root,\ cumulus,\ san/g'
systemctl restart netd.service  
#四 管理 

# timezone，本地时间，ntp,syslog（针对级别进行过滤）,snmp(spine\leaf,tor),修改lldp for neo 
# IP 地址,NTP 通过dhcp 获取,hostname 包含某些字段 （带外）
if [[ $(hostname -s) = *2700* ]]; then
  echo "*.warn action(type="omfwd" target="192.168.0.254" Device="mgmt" Port="514" Protocol="udp")" > /etc/rsyslog.d/11-remotesyslog.conf
  
#  echo "nameserver 10.10.10.10#vrf mgmt" >>  /etc/resolv.conf
fi
 

# 五、安装包
#5.1、修改本地仓库源
sed -i /etc/apt/sources.list -e 's/repo3.cumulusnetworks.com\/repo/192.168.0.254/'
#5.2、安装gcc libpcre3 libpcre3-dev openssl libssl-dev （见下方配置）

#5.3、tacas（修改权限，配置taca--ansible）
#/etc/tacplus_servers 
#/etc/netd.conf （上面配置了）

#Update Package Cache 
apt-get update -y
 
#Installing the TACACS+ Client Packages 
apt-get install -y tacplus-client gcc libpcre3 libpcre3-dev openssl libssl-dev --force-yes

#六、配vlan (建议ansible playbook ） 

# 七、配置dhcp relay, 只有TOR 
if [[ $(hostname -s) = *tor* ]]; then
  sed -i '/SERVERS=/d' /etc/default/isc-dhcp-relay
  sed -i '/INTF_CMD=/d' /etc/default/isc-dhcp-relay
  echo "SERVERS="10.22.57.217"" > /etc/default/isc-dhcp-relay
  echo "INTF_CMD="-i vlan100 -i swp49 -i swp50 -i swp51 -i swp52 -i swp53 -i swp54 -i swp55 -i swp56"" >> /etc/default/isc-dhcp-relay
fi
# CUMULUS-AUTOPROVISIONING
# Waiting for NCLU to finish starting up
last_code=1
while [ "1" == "$last_code" ]; do
    net show interface &> /dev/null
    last_code=$?
done
 
net add time zone Etc/UTC
net commit

exit 0
