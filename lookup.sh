
# hladaj pocitace na F135

#IPCKY=$(netdiscover -r 194.160.41.0/24 -P | grep "Micro-Star" | awk '{ print $1 }')
IPCKY=$(netdiscover -r 192.168.36.0/24 -P | grep "ASRock Incorporation" | awk '{ print $1 }')


{
echo "f135:"
echo "  hosts:"
COUNT=1
for IP in $IPCKY
do
	echo "    PC${COUNT}:"
	echo "      ansible_host: ${IP}"
	COUNT=$((COUNT+1))
done
} > inventory-f135.yaml

