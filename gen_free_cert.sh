#!/bin/bash

DNS_NAME=""
#DNS_NAME="irongatevpn.p-e.kr"
#DNS_NAME="irongatevpn.kro.kr"

# letsencrypt certonly --webroot --webroot-path=/var/www/html -d irongatevpn.p-e.kr -d www.irongatevpn.p-e.kr


copy_cert() {
	# copy /etc/ssl/certs/DST_Root_CA_X3.pem
	local LETS_CA_PEM="DST_Root_CA_X3.pem"
	local ROOT_CA="/etc/ipsec.d/cacerts/$LETS_CA_PEM"
	local SRC_ROOT_CA="/etc/ssl/certs/$LETS_CA_PEM"
	local LIVE_DIR="/etc/letsencrypt/live/$DNS_NAME"
	local SWANCTL_DIR="/etc/swanctl"

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
	local dns=$DNS_NAME
	local www="www.$DNS_NAME"
	ufw allow 80/tcp

	certbot certonly -m irongate11@gmail.com --agree-tos --standalone -n -d $dns -d $www
	# letsencrypt certonly --webroot --webroot-path=/var/www/html -d irongatevpn.p-e.kr -d www.irongatevpn.p-e.kr

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

print_usage() {
	echo "gen_free_cert -d <your dns name> <-i | -r>"
	echo "-i: install free certificate"
	echo "-r: renew the certificate installed"
	exit 1
}

###########################
CMD=""

while [[ "$#" -gt 0 ]]; do 
	case $1 in
	-d) 
		DNS_NAME="$2"
		shift 2
		;;
	-i) 
		CMD="gen"
		shift
		;;
	-r) 
		CMD="renew"
		shift
		;;
	*) 
		echo "Unknown parameter passed: $1"
		shift
		;;
	esac; 
done

if [ "_$DNS_NAME" == "_" ]; then
	echo "DNS_NAME is empyt"
	print_usage
fi

if [ "$CMD" == "gen" ]; then
	#echo $CMD
	#echo "$DNS_NAME"
	gen_cert
elif [ "$CMD" == "renew" ]; then
	#echo $CMD
	#echo "$DNS_NAME"
	renew_cert
elif [ "_$CMD" == "_" ]; then
	echo "No cmd, assign command"
	print_usage
else
	echo "Unknown cmd: $CMD"
	print_usage
fi
