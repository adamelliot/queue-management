#! /bin/bash
# Runs all scripts in ./scripts folder
# This script should be run on a booted pi or a loaded container

set -ex

# TODO: Discuss how we want to set user variables
export username='bcservices'
export password='password'
export sshd_port=22022
export hostname=mended

export files=`pwd`/files
export home_dir="/home/${username}"

for f in ./scripts/*; do
  sudo -E bash -c "$f"
done
