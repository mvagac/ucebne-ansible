#!/bin/bash

# hladaj pocitace na danej ucebni

if [ $# -ne 1 ]
then
	echo "zadaj ucebnu: f135|f137"
	exit
fi

UCEBNA=$1

if [ $UCEBNA == "f135" ]
then
	IPCKY=$(netdiscover -r 194.160.41.0/24 -P | grep "Micro-Star" | awk '{ print $1 }')
fi

if [ $UCEBNA == "f137" ]
then
	IPCKY=$(netdiscover -r 192.168.36.0/24 -P | grep "ASRock Incorporation" | awk '{ print $1 }')
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

