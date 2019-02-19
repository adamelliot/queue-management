#! /bin/bash
#
# This file generates all system wide information for this smartboard
# at boot time and stores them in /var/smartboard
#
# Inputs: ${smartboard_base_url} is imported in via the artifact building process
#

mkdir -p /var/smartboard/

# Get Ethernet mac address
IFACE=e*
read LOCALMAC </sys/class/net/$IFACE/address

# Set address correctly based on MAC Address
while read mac tzpi smartboard_id remainder
do
    if [[ $LOCALMAC == $mac ]]; then
	        TZPI=$tzpi;
            SMARTBOARD_ID=$smartboard_id;
    fi
done < /data/sites.txt

# Leave the test URL with it's zone in the config so the 
# application knows what to load
echo $SMARTBOARD_ID > /var/smartboard/id
echo $TZPI > /var/smartboard/timezone
echo "${smartboard_base_url}" > /var/smartboard/base-url
echo "${smartboard_base_url}/smartboard/${SMARTBOARD_ID}?tz=${TZPI}&localvideo=1" > /var/smartboard/url
echo "${smartboard_base_url}/static/videos/manifest.json" > /var/smartboard/manifest-url
echo "${fallback_video_timeout}" > /var/smartboard/fallback-video-timeout
