#!/bin/bash

wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/InstallandSetup.sh -O /tmp/InstallandSetup.sh

chmod +x /tmp/InstallandSetup.sh

echo "Installing and Setting up DgSecure.."
sudo sh /tmp/InstallandSetup.sh $1
echo "DgSecure Installation and Setup finished."

