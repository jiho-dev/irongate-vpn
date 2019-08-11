#!/bin/bash


copy_files() {
	local base_dir=$1

	shift

	while [ $# -gt 0 ]
	do
		f="$base_dir/$1"
		if [ -d $f ]; then
			echo "DIR:$f"
			cp -r $f .
		else
			echo "FILE: $f"
			cp $f .
		fi
		
		shift
	done
}

bak=config-$(date +%F_%H-%M-%S)
echo $bak

if [ -e $bak ]; then
	echo "$bak exists !!"
	exit -1
fi

mkdir $bak
cd $bak


etc_files="swanctl strongswan.conf strongswan.d  stunnel ufw"
copy_files "/etc" $etc_files

