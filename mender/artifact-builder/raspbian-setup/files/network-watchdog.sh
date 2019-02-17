#! /bin/bash

# Get Ethernet mac address
IFACE=e*
read LOCALMAC </sys/class/net/$IFACE/address

# Set address correctly based on MAC Address
while read mac tzpi url remainder
do
    if [[ $LOCALMAC == $mac ]]; then
	        TZPI=$tzpi;
            URL=$url;
    fi
done < /data/sites.txt

# Leave the test URL with it's zone in the config so the 
# application knows what to load
echo "${URL}?tz=${TZPI}&localvideo=1" > /var/smartboard-url

NETWORK_DOWN=0
# 15 Minutes
RETRIES=180
TIMEOUT=5

while true ; do
	wget -q -O /dev/null "$URL"
	if [ $? -gt 0 ] ; then
		NETWORK_DOWN=$((NETWORK_DOWN + 1))
		echo "Network down, attempt number: ${NETWORK_DOWN}"

		systemctl restart systemd-networkd
		touch /var/network-down
	else
		NETWORK_DOWN=0

		if [ -e /var/network-down ] ; then
			rm /var/network-down
		fi
	fi

	if [ $NETWORK_DOWN -gt $RETRIES ] ; then
		reboot
	fi

	# We check every 5 seconds for network connection
	sleep $TIMEOUT
done
