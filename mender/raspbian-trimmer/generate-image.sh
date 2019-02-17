#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ "$#" -ne 1 ]; then
  echo "ERROR: Need to provide source image."
  exit 1
fi

INPUT_IMAGE=$1
INPUT_NAME=$(basename $1)

$DIR/prepare-raspbian/docker-build
$DIR/shrink-image/docker-build

$DIR/prepare-raspbian/prepare-raspbian $INPUT_IMAGE
$DIR/shrink-image/shrink-image $INPUT_IMAGE

mv $DIR/shrink-image/output/$INPUT_NAME $INPUT_IMAGE
