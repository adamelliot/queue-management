#!/bin/sh
set -e

INPUT=$1

pishrink.sh -s /image/$INPUT /output/$INPUT
