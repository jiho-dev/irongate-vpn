# irongate-vpn

irongate-vpn is VPN service using Strongswan. It uses IKEv2 as a basic Key Management Protocol, which can connect with iOS, Androd(Strongswan client) and Windows 10 and Linux without any extra Apps or Programs

# VPN Server
* Server Name: irongatevpn.kro.kr
* Web: http://www.irongatevpn.kro.kr:800

# VPN Service settings for Andriod (Alpha test)
* vpn server: irongatevpn.kro.kr
* VPN type: IKEv2 EAP(Username/Password)
* Username: vpnuser1
* Password: 
* CA certificate: select automatically
* Profile name: irongatevpn

# How to use
* git clone https://github.com/jhjgithub/irongate-vpn.git
* cd irongate-vpn
* chmod 777 *.sh
* run init_system.sh

# Todo
* crontab should be modified to update Let's Encrypt certification in every 3 months

# Android
* Install strongswan client on Playstore
* Or use the link to download it: https://download.strongswan.org/Android/strongSwan-2.1.1.apk
