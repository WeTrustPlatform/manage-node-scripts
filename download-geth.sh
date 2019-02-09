#! /bin/bash

# This script downloads the Geth binary,
# verify MD5 checksum, gpg signature
# and untar it in the `tmp` folder
# under the same directory.
# Usage:
# ./download-geth.sh <geth-linux-amd64-1.8.22-7fa3509e.tar.gz> <md5sum>
#

GPG_KEY="0xA61A13569BA28146"
GPG_FINGERPRINT="FDE5 A1A0 44FA 13D2 F7AD  A019 A61A 1356 9BA2 8146"
TEMP_DIR=tmp
DOWNLOAD_PATH=https://gethstore.blob.core.windows.net/builds

# no-verbose no-clobber
WGET="wget -nc -nv"

if [ -n "$1" ]; then
  if [ -z "$2" ]; then
    echo "Missing MD5 checksum!"
    exit 1
  fi

  echo ">> Creating $TEMP_DIR folder and cd"
  mkdir -p $TEMP_DIR
  cd $TEMP_DIR

  echo ">> Downloading binary $1"
  $WGET $DOWNLOAD_PATH/$1

  echo ">> Verifying MD5 checksum"
  echo "$2 $1" > $1.md5
  md5sum --quiet -c $1.md5 || exit 1

  echo ">> Checksum verified"

  echo ">> Downloading signature $1.asc"
  $WGET $DOWNLOAD_PATH/$1.asc

  echo ">> Check if public key has been imported"
  gpg --list-key $GPG_KEY
  if [ $? -ne 0 ]; then
    echo ">> Getting key $GPG_KEY"
    gpg --keyserver keyserver.ubuntu.com --recv $GPG_KEY
  fi

  echo ">> Verifying GPG signature"
  # 2>&1 because of the unknown signature warning
  gpg --verify $1.asc 2>&1 | grep "$GPG_FINGERPRINT"
  if [ $? -ne 0 ]; then
    echo ">> Error: Fingerprint does not match!"
    exit 1
  fi
  echo ">> GPG signature verified"

  echo ">> Unpacking tar"
  tar xvf $1
  echo ">> Done!"
  exit 0
else
  echo ">> Missing file name! i.e. geth-linux-amd64-1.8.22-7fa3509e.tar.gz"
  exit 1
fi
