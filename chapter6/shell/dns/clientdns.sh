#!/bin/bash

apt update

if [[ $? -ne 0 ]];then
		echo "apt update failed!"
	exit
fi

apt install resolvconf

if [[ $? -ne 0 ]];then
		echo "install resolvconf failed!"
	exit
fi

head="/etc/resolvconf/resolv.conf.d/head"
cat<<EOT >>"$head"
search cuc.edu.cn
nameserver 192.168.56.102
EOT

