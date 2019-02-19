#! /bin/bash
#
# The primer is used to preload most of the packages we will want on the RPi
# this will reduce time used in the artifact building. The artifact builder
# will ensure that all required packages are installed.

# Copied from raspbian-setup/files/deps_add.txt
read -r -d '' PACKAGES << 'Packages'
python3
avahi-daemon
ntp
libavahi-client3
ufw
ifplugd
wpasupplicant
openbox
xserver-xorg
xserver-xorg-legacy
xinit
unclutter
matchbox-window-manager
x11-xserver-utils
gstreamer1.0-libav
nginx
supervisor
python3-venv
fim
fuse
xloadimage
jq
Packages

set -ex

apt-get update
apt-get upgrade -y

apt-get install -y --no-install-recommends $(echo $PACKAGES | tr '\n' ' ')
apt-get install -y luakit

apt-get -y --purge autoremove
apt-get clean

rm /var/lib/apt/lists/* -vf 

shopt -s extglob

# Remove non-english locales
rm -rf /usr/share/locale/!(en|en*|locale.alias)
rm -rf /usr/share/i18n/locales/!(en|en*|translit)

# Remove unsued documentation:
rm -rf /usr/share/doc
