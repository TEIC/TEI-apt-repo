#!/bin/bash

# This script is intended to facilitate the process
# of creating an up-to-date Docker image for the TEI-apt-repo.
#
# It assumes you have Docker installed and the TEI's private 
# GPG key in your keyring, and will ask for the corresponding passphrase.
# With this information it will spin up a temporary NGINX server
# to provide these to the main Docker build file.

# name for the newly created Docker image 
IMAGE_NAME=tei-apt-repo

# the ID of the TEI's private GPG key 
KEY_ID=05E343E28C2E781B6DF3490319CF3E497B9824DC

# params for the temporary NGINX container
# a) the port that will be opened on the host machine and 
# b) the associated Docker container name
NGINX_PORT=9090
NGINX_NAME=secretsprovider

# create some temporary files to hold the exported key
# and the passphrase
KEY_FILE=`mktemp`
PASSPHRASE_FILE=`mktemp`

# ask the user for the passphrase
echo "Please enter passphrase and hit enter:"
read -s PASSWD

# … and write it to the temporary file
echo ${PASSWD} > ${PASSPHRASE_FILE}

# export the GPG key
# on my Mac, it does not work with batch mode but the gpgp agent asks for a password (for the second time) 
gpg --export-secret-keys --no-tty --batch --passphrase-file ${PASSPHRASE_FILE} --armor ${KEY_ID} > ${KEY_FILE}

# start up the temporary NGINX server for serving the keyfile and passphrase
# explicitly pull the image first to make sure we have a recent one 
docker pull nginx:alpine
docker run --rm -d --name ${NGINX_NAME} -p ${NGINX_PORT}:80 -v ${PASSPHRASE_FILE}:/usr/share/nginx/html/secret.pass -v ${KEY_FILE}:/usr/share/nginx/html/secret.key nginx:alpine

# wait 5 seconds for the NGINX to come up
# and start the main build
sleep 5
docker build -t ${IMAGE_NAME} --build-arg GPG_PASS_URL=http://localhost:${NGINX_PORT}/secret.pass --build-arg GPG_KEY_URL=http://localhost:${NGINX_PORT}/secret.key  .

# clean up
# remove Docker container and temporary files
docker kill ${NGINX_NAME}
rm -rf ${KEY_FILE}
rm -rf ${PASSPHRASE_FILE}
