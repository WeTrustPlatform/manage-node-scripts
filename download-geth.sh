#! /bin/bash

# This script downloads the Geth binary,
# verify MD5 checksum, gpg signature
# and untar it in the `tmp` folder
# under the same directory.
# Usage:
# ./download-geth.sh 1.8.23
#

GPG_KEY="0xA61A13569BA28146"
GPG_FINGERPRINT="FDE5 A1A0 44FA 13D2 F7AD  A019 A61A 1356 9BA2 8146"
TEMP_DIR=tmp
DOWNLOAD_PATH=https://gethstore.blob.core.windows.net/builds

# no-verbose no-clobber
WGET="wget -nc -nv"

if [ -n "$1" ]; then

  echo ">> Creating $TEMP_DIR folder and cd"
  mkdir -p $TEMP_DIR
  cd $TEMP_DIR

  # this script set values of file_name and md5_value
  source ../search.sh

  echo ">> Downloading binary $file_name"
  $WGET $DOWNLOAD_PATH/$file_name

  echo ">> Verifying MD5 checksum"
  echo "$md5_value $file_name" > $file_name.md5
  # Linux
  # md5sum --quiet -c $file_name.md5 || exit 1"
  md5 -r $file_name | diff $file_name.md5 - || exit 1

  echo ">> Checksum verified"

  echo ">> Downloading signature $file_name.asc"
  $WGET $DOWNLOAD_PATH/$file_name.asc

  echo ">> Check if public key has been imported"
  gpg --list-key $GPG_KEY
  if [ $? -ne 0 ]; then
    echo ">> Getting key $GPG_KEY"
    gpg --keyserver keyserver.ubuntu.com --recv $GPG_KEY
  fi

  echo ">> Verifying GPG signature"
  # 2>&1 because of the unknown signature warning
  gpg --verify $file_name.asc 2>&1 | grep "$GPG_FINGERPRINT"
  if [ $? -ne 0 ]; then
    echo ">> Error: Fingerprint does not match!"
    exit 1
  fi
  echo ">> GPG signature verified"

  echo ">> Unpacking tar"
  tar xvf $file_name
  echo ">> Done!"
  exit 0
else
  echo ">> Please specify version! i.e. 1.8.22"
  exit 1
fi
