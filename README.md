**irongate-vpn**
=============================
irongate-vpn is VPN service using Strongswan. It uses IKEv2 as a basic Key Management Protocol, which can connect with iOS, Androd(Strongswan client) and Windows 10 and Linux without any extra Apps or Programs

### VPN Server
* Server Name: irongatevpn.kro.kr
* Web: https://www.irongatevpn.kro.kr

### VPN Service settings for Andriod (Alpha test)
First, you have to install strongswan client Apps.  Follow the directions below.  
If you are out of China, install strongswan client on Google Playstore.  
But in China, use the link to download it  
* https://download.strongswan.org/Android/strongSwan-2.1.1.apk  
----------------------------
* run strongswan apps in your phone
* add profile and enter the parameters below

<pre><code>
* vpn server: irongatevpn.kro.kr
* VPN type: IKEv2 EAP(Username/Password)
* Username: vpnuser1
* Password: ~~(ask me)~~  
* CA certificate: select automatically
* Profile name: irongatevpn
</code></pre>

![Alt text](3.add_profile.jpg?raw=true "Add Profile")
![Alt text](4.server_setup.jpg?raw=true "Setup server")

### VPN Service settings for iPhone (Alpha test)
![Alt text](5.iphone_setup.png?raw=true)
![Alt text](5.iphone_setup-eng.png?raw=true)


### VPN Service settings for Windws 10 (Alpha test)
* TBA

### How to use
* git clone https://github.com/jhjgithub/irongate-vpn.git
* cd irongate-vpn
* chmod 777 *.sh
* run init_system.sh

### Todo
* crontab should be modified to update Let's Encrypt certification in every 3 months


