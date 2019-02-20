#!/bin/bash

sudo systemctl stop splashscreen

xsetroot -solid white 
xsetbg -onroot -shrink -fullscreen -smooth -background white /var/flaskapp/web-service/static/splash.png

# disable DPMS (Energy Star) features.
xset -dpms
# disable screen saver
xset s off
# don't blank the video device
xset s noblank
# disable mouse pointer
unclutter &
# run window manager
matchbox-window-manager -use_cursor no -use_titlebar no  &

luakit -n "http://localhost/splash.html"

# We need to wait for the first instance to start fighting with TLS
# before we load the second. That ensures that the HTTPS requests
# don't fail. A newer version of luakit will fix this.
sleep 15

# Start up browser, and keep it alive if it crashes / terminates for some reason.
while true ; do
	# Launch a splash screen first and let the webservice tell us when it's safe
	# to try load the smart board. This ensures that the network is up
	# before hitting the smartboard
	luakit "http://localhost/splash.html"

	sleep 1
	# Clean out any lingering processes if luakit has died
	killall -HUP luakit
	sleep 2
done 
