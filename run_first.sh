#!/bin/bash

URL="https://s3.amazonaws.com/ddig-puppet/"
PE_INSTALLER="puppet-enterprise-3.7.2-el-6-x86_64.tar.gz"
PE_WIN_AGENT="puppet-enterprise-3.7.2-x64.msi"
BONJOUR_WIN_CLIENT="Bonjour64.msi"

mkdir ./bin
cd ./bin

# Check for Puppet Enterprise installer and download if missing
echo -e "\nVerifying that Puppet Enterprise installer is available..."
if [ ! -f $PE_INSTALLER ]; then
    echo "Puppet Enterprise installer not found. Downloading..."
    curl -O $URL$PE_INSTALLER
else
    echo "Puppet Enterprise installer was found."
fi


# Check for Puppet Enterprise Windows agent and download if missing
echo -e "\nVerifying that Puppet Enterprise Windows agent is available..."
if [ ! -f $PE_INSTALLER ]; then
    echo "Puppet Enterprise Windows agent not found. Downloading..."
    curl -O $URL$PE_WIN_AGENT
else
    echo "Puppet Enterprise Windows agent was found."
fi


# Check for Bonjour client for Windows and download if missing
echo -e "\nVerifying that Bonjour client for Windows is available..."
if [ ! -f $PE_INSTALLER ]; then
    echo "Bonjour client for Windows not found. Downloading..."
    curl -O $URL$PE_WIN_AGENT
else
    echo "Bonjour client for Windows agent was found."
fi


echo -e "\nYou're all set! Run '\033[36mvagrant up\033[0m' to get started."