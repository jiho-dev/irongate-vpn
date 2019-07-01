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

# utility
apt -y install rsyslog inetutils-ping

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

git clone https://github.com/jhjgithub/strongMan.git
cd strongMan
./install.sh

# crontab 수정 하기


