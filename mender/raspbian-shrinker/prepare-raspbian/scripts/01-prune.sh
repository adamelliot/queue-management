#! /bin/bash

set -ex

apt-get remove -y build-essential samba-common libasound2 libasound2-data \
	alsa-utils binutils manpages manpages-dev man-db cpp gcc-6 firmware-atheros \
	firmware-libertas firmware-misc-nonfree firmware-realtek gdb plymouth libplymouth4 \
	libraspberrypi-doc perl-modules-5.24 iso-codes libc6-dev

apt-get -y --purge autoremove
apt-get clean

rm -rf /var/cache/man
rm -rf /usr/share/man

shopt -s extglob

# Remove non-english locales
rm -rf /usr/share/locale/!(en|en*|locale.alias)
rm -rf /usr/share/i18n/locales/!(en|en*|translit)

# Remove unsued documentation:
rm -rf /usr/share/doc

# Disable swap space
dphys-swapfile swapoff
dphys-swapfile uninstall 
systemctl disable dphys-swapfile

# Remove swap file
if [ -f /var/swap ] ; then
	rm /var/swap
fi

# Clean out apt lists we don't need
rm /var/lib/apt/lists/* -vf 
