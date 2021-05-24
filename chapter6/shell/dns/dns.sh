#!/bin/bash

apt update

if [[ $? -ne 0 ]];then
		echo "apt update failed!"
	exit
fi

apt install -y bind9

if [[ $? -ne 0 ]];then
		echo "install bind9 failed!"
		exit
fi

options="/etc/bind/named.conf.options"
local="/etc/bind/named.conf.local"
cp1="/etc/bind/db.local"
cp2="/etc/bind/db.cuc.edu.cn"

tail -n 1 "$options"
cat<<EOT >>"$options"
acl "trusted" {
      192.168.56.102;    # ns1 - can be set to localhost
};  
listen-on { 192.168.56.102; };
allow-transfer { none; };
forwarders {
    8.8.8.8;
    8.8.4.4;
};
};
EOT

cat<<EOT >>"$local"
zone "cuc.edu.cn" {
    type master;
    file "/etc/bind/db.cuc.edu.cn";
};
EOT

cp "$cp1" "$cp2"

cat<<EOT >>"$cp2"
IN      NS      ns.cuc.edu.cn.
ns      IN      A       192.168.56.102
wp.sec.cuc.edu.cn.      IN      A       192.168.56.102
dvwa.sec.cuc.edu.cn.    IN      CNAME   wp.sec.cuc.edu.cn.
EOT

service bind9 restart



















