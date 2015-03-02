#!/bin/bash

INSTALLER="puppet-enterprise-3.7.2-el-6-x86_64.tar.gz"
URL="https://s3.amazonaws.com/ddig-puppet/"

echo -e "\nVerifying that Puppet Enterprise installer is available..."

if [ ! -f $INSTALLER ]; then
    echo "Puppet Enterprise installer not found. Downloading..."
    curl -O $URL$INSTALLER
else
    echo "Puppet Enterprise installer was found."
fi

echo -e "\nYou're all set! Run '\033[36mvagrant up\033[0m' to get started."