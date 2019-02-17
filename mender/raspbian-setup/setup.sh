#! /bin/bash
# Runs all scripts in ./scripts folder
# This script should be run on a booted pi or a loaded container

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -ex

# TODO: Discuss how we want to set user variables
export username='bcservices'
export password='password'
export sshd_port=22022
export hostname=mended

# Net health timeouts
# Pull sites.txt / wpa_supplicant from env path

export files=`pwd`/files
export home_dir="/home/${username}"

for f in $DIR/scripts/*; do
  sudo -E bash -c "$f"
done
