#!/bin/bash

black=0; red=1; green=2; yellow=3; blue=4; pink=5; cyan=6; white=7;
cecho () {
	#local _color=$1; shift
	local _color=$green
	echo -e "$(tput setaf $_color)$@$(tput sgr0)"
}

############################
# install packages

cecho "### updating package ###"
apt -y update
apt -y upgrade

# IPSEC 설치
apt -y install strongswan strongswan-pki libcharon-extra-plugins libstrongswan-extra-plugins
apt -y install strongswan-swanctl charon-systemd

# for strongMan
apt -y install python-pip sqlite python3-distutils virtualenv stunnel4 python3-pip

# utility
apt -y install rsyslog inetutils-ping conntrack

# 무료 인증서: let's encrypt
apt -y install certbot

########################
## remove packages 
cecho "### cleaning package ###"
systemctl stop unattended-upgrades
apt -y remove unattended-upgrades

systemctl stop lxcfs
systemctl stop snapd 
apt -y remove lxcfs snapd

# cleaning
apt -y autoremove


##########################
# setup system

# timezone
cecho "### setup timezone ###"
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# swanctl
cecho "### setup swanctl ###"
cp /etc/swanctl/swanctl.conf /etc/swanctl/swanctl.conf.org
cp swanctl.conf /etc/swanctl/swanctl.conf
cp secrets.conf /etc/swanctl/conf.d/

# ufw
cecho "### setup firewall ###"
cp before.rules /etc/ufw/
cp user.rules   /etc/ufw/
cp sysctl.conf  /etc/ufw/
cp ufw          /etc/default/

# enable firewall
ufw --force enable

###################
# start service

./gen_free_cert.sh -i

swanctl -r
swanctl -q

###########
## setup webui

cecho "### setup WebUI"

if [ ! -d /etc/stunnel ]; then
	mkdir -p /etc/stunnel
fi

cp -f stunnel.conf /etc/stunnel/
cp -f stunnel4 /etc/default/
cp -f stunnel4.service /lib/systemd/system/

# remove old one
systemctl stop stunnel4
systemctl disable stunnel4
#systemctl restart stunnel4

# enable new one
systemctl enable stunnel4.service
systemctl start stunnel4.service

git clone https://github.com/jhjgithub/strongMan.git
cd strongMan
./install.sh

# crontab 수정 하기


