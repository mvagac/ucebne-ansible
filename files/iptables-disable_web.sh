#!/bin/sh

/sbin/iptables -F
/sbin/iptables -X
/sbin/iptables -Z

/sbin/iptables -t nat -F
/sbin/iptables -t nat -X
/sbin/iptables -t nat -Z

#IFACE=$(ip a | grep "state UP" | awk '{ print $2 }')
#IFACE=${IFACE%:}


# ----- INPUT -----------------------------------------------------------
/sbin/iptables -P INPUT DROP

/sbin/iptables -A INPUT -s 127.0.0.1 -j ACCEPT

# ssh
/sbin/iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# service
/sbin/iptables -A INPUT -p ICMP --icmp-type 0 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 3 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 8 -j ACCEPT
/sbin/iptables -A INPUT -p ICMP --icmp-type 11 -j ACCEPT
/sbin/iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# ----- OUTPUT -----------------------------------------------------------
/sbin/iptables -P OUTPUT DROP

/sbin/iptables -A OUTPUT -d 127.0.0.1 -j ACCEPT

# dns
/sbin/iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# ldap
/sbin/iptables -A OUTPUT -d 194.160.44.75 -j ACCEPT

# lms
/sbin/iptables -A OUTPUT -p tcp -d lms.umb.sk -j ACCEPT
/sbin/iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#?/sbin/iptables -A OUTPUT -d 194.160.44.0/24 -j ACCEPT
#?/sbin/iptables -A OUTPUT -d 194.160.44.8 -j ACCEPT
#?/sbin/iptables -A OUTPUT -p tcp -m string --string "lms.umb.sk" --algo kmp -j ACCEPT

# service
/sbin/iptables -A OUTPUT -p ICMP --icmp-type 0 -j ACCEPT
/sbin/iptables -A OUTPUT -p ICMP --icmp-type 3 -j ACCEPT
/sbin/iptables -A OUTPUT -p ICMP --icmp-type 8 -j ACCEPT
/sbin/iptables -A OUTPUT -p ICMP --icmp-type 11 -j ACCEPT
/sbin/iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

# ----- FORWARD -----------------------------------------------------------
/sbin/iptables -P FORWARD DROP

exit 0

