#!/bin/bash

xsetroot -solid white 
xsetbg -onroot -background white -center /var/flaskapp/web-service/static/splash.png

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

# Sleep for a few seconds to make sure everything is up and running
sleep 3

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
