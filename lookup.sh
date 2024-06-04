#!/bin/bash

# hladaj pocitace na danej ucebni

if [ $# -ne 1 ]
then
	echo "zadaj ucebnu: f135|f137"
	exit
fi

UCEBNA=$1

IFACE=$(ip a | grep enp | head -1 | cut -d":" -f2)
IPADDR=$(ip addr show $IFACE | grep "inet " | awk '{print $2}')
IPPARTS=(${IPADDR//./ })
NETADDR="${IPPARTS[0]}.${IPPARTS[1]}.${IPPARTS[2]}.0/24"

if [ $UCEBNA == "f135" ]
then
	IPCKY=$(netdiscover -r $NETADDR -P | grep "Micro-Star" | awk '{ print $1 }')
fi

if [ $UCEBNA == "f137" ]
then
	IPCKY=$(netdiscover -r $NETADDR -P | grep "ASRock Incorporation" | awk '{ print $1 }')
fi

{
echo "$UCEBNA:"
echo "  hosts:"
COUNT=1
for IP in $IPCKY
do
	echo "    PC${COUNT}:"
	echo "      ansible_host: ${IP}"
	COUNT=$((COUNT+1))
done
} > inventory-${UCEBNA}.yaml

