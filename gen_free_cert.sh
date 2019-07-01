#!/bin/bash
#DNS="irongatevpn.p-e.kr"
DNS="irongatevpn.kro.kr"

# copy /etc/ssl/certs/DST_Root_CA_X3.pem
LETS_CA_PEM="DST_Root_CA_X3.pem"
ROOT_CA="/etc/ipsec.d/cacerts/$LETS_CA_PEM"
SRC_ROOT_CA="/etc/ssl/certs/$LETS_CA_PEM"
LIVE_DIR="/etc/letsencrypt/live/$DNS"
SWANCTL_DIR="/etc/swanctl"

copy_cert() {
	if [ -d $LIVE_DIR ]; then
		echo "Copy cert files into ipsec.d"
		cp $LIVE_DIR/cert.pem /etc/ipsec.d/certs/
		cp $LIVE_DIR/fullchain.pem /etc/ipsec.d/certs/
		cp $LIVE_DIR/privkey.pem /etc/ipsec.d/private/
		cp $LIVE_DIR/chain.pem /etc/ipsec.d/cacerts/

		if [ -d "$SWANCTL_DIR" ]; then
			echo "Copy cert files into swanctl"
			cp $LIVE_DIR/cert.pem $SWANCTL_DIR/x509/
			cp $LIVE_DIR/fullchain.pem $SWANCTL_DIR/x509/
			cp $LIVE_DIR/privkey.pem $SWANCTL_DIR/private/
			cp $LIVE_DIR/chain.pem $SWANCTL_DIR/x509ca/
		fi

		#if [ ! -e $ROOT_CA ]; then
		#    cp $SRC_ROOT_CA $ROOT_CA
		#fi

		echo "Success !"
	fi
}

gen_cert() {
	ufw allow 80/tcp

	certbot certonly -m irongate11@gmail.com --agree-tos --standalone -n -d $DNS

	ufw delete allow 80/tcp

	copy_cert

	swanctl -r
	swanctl -q
}

renew_cert() {
	local ofile=$(readlink -f $LIVE_DIR/cert.pem)

	ufw allow 80/tcp

	#certbot renew --force-renewal -m irongate11@gmail.com --agree-tos --standalone -n
	certbot renew -m irongate11@gmail.com --agree-tos --standalone -n

	ufw delete allow 80/tcp

	local nfile=$(readlink -f $LIVE_DIR/cert.pem)

	if [ "$ofile" != "$nfile" ]; then
		copy_cert
		swanctl -r
		swanctl -q
	fi
}

###########################

while [[ "$#" -gt 0 ]]; do 
	case $1 in
	-i) 
		gen_cert
		shift
		;;
	-r) 
		renew_cert
		shift
		;;
	*) 
		echo "Unknown parameter passed: $1"
		exit 1
		;;
	esac; 
	shift; 
done

