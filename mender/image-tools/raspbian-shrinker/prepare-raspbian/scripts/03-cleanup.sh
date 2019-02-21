#! /bin/bash

set -ex

apt-get -y --purge autoremove
apt-get clean

shopt -s extglob

# Remove non-english locales
rm -rf /usr/share/locale/!(en|en*|locale.alias)
rm -rf /usr/share/i18n/locales/!(en|en*|translit)

# Remove unsued documentation:
rm -rf /usr/share/doc

# Clean out apt lists we don't need
rm -rf /var/lib/apt/lists/*
