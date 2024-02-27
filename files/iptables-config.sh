#!/bin/sh

/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z

/sbin/iptables -t nat -F
/sbin/iptables -t nat -X
/sbin/iptables -t nat -Z

IF_GLOBAL=eth0

# ----- INPUT -----------------------------------------------------------
/sbin/iptables -P INPUT DROP
/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT

/sbin/iptables -A INPUT -s 43.255.189.88 -j DROP
/sbin/iptables -A INPUT -s 194.160.34.164/32 -j ACCEPT

# public
#-------
# ssh
/sbin/iptables -A INPUT -i ${IF_GLOBAL} -p tcp --dport 22 -j ACCEPT
# apache
/sbin/iptables -A INPUT -i ${IF_GLOBAL} -p tcp -s 194.160.0.0/16 --dport 80 -j ACCEPT
/sbin/iptables -A INPUT -i ${IF_GLOBAL} -p tcp --dport 443 -j ACCEPT
# service
/sbin/iptables -A INPUT -p ICMP --icmp-type 0 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 3 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 8 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 11 -j ACCEPT
/sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# mailDav
/sbin/iptables -A INPUT -i ${IF_GLOBAL} -p tcp --dport 1143 -j ACCEPT
/sbin/iptables -A INPUT -i ${IF_GLOBAL} -p tcp --dport 1110 -j ACCEPT
/sbin/iptables -A INPUT -i ${IF_GLOBAL} -p tcp --dport 1025 -j ACCEPT

# obmedzene sluzby
#-----------------
# zabbix
/sbin/iptables -A INPUT -s 194.160.44.27 -p tcp --dport 10050 -j ACCEPT
/sbin/iptables -A INPUT -s 194.160.44.27 -p tcp --dport 389 -j ACCEPT

# zabbix test
/sbin/iptables -A INPUT -s 194.160.45.246 -p tcp --dport 389 -j ACCEPT

# ARL Kniznicny system
/sbin/iptables -A INPUT -s 86.110.225.117 -p tcp --dport 636 -j ACCEPT
/sbin/iptables -A INPUT -s 31.192.66.98 -p tcp --dport 636 -j ACCEPT

# login.umb.sk EDUID
/sbin/iptables -A INPUT -s 194.160.44.124 -p tcp --dport 636 -j ACCEPT

# ntp
/sbin/iptables -A INPUT -s 194.160.41.0/24 -p udp --dport 123 -j ACCEPT
/sbin/iptables -A INPUT -s 194.160.41.0/24 -p tcp --dport 123 -j ACCEPT
/sbin/iptables -A INPUT -s 194.160.44.0/24 -p udp --dport 123 -j ACCEPT
/sbin/iptables -A INPUT -s 194.160.44.0/24 -p tcp --dport 123 -j ACCEPT
# ldap
ALLOWED_HOSTS=$(cut -f1 /root/iptables-allowed_hosts.txt |grep -v "^#")
for HOST in ${ALLOWED_HOSTS}
do
	# ldap
	/sbin/iptables -A INPUT -i ${IF_GLOBAL} -s ${HOST} -p tcp --dport 389 -j ACCEPT
	/sbin/iptables -A INPUT -i ${IF_GLOBAL} -s ${HOST} -p tcp --dport 636 -j ACCEPT
done

# ----- FORWARD -----------------------------------------------------------
/sbin/iptables -P FORWARD DROP

exit 0

