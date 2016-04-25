#!/usr/bin/env bash

## We will install MongoDB Community Edition packages which are more up to date. MongoDB only provides Community Edition packages for 64-bit Debian “Wheezy”.
## These packages may work with other Debian releases. Note that Debian “Jessie“ like other Debian distributions also includes its own MongoDB packages.

# Import public key of MongoDB apt repository in our system
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# Add MongoDB APT repository url in /etc/apt/sources.list.d/mongodb.list
echo "deb http://repo.mongodb.org/apt/debian ""wheezy""/mongodb-org/3.2 main" | sudo tee /etc/apt/sources.list.d/mongodb.list
# Update system with new added repository
apt-get update
# Install MongoDB system
apt-get install -y mongodb-org
# Restart/Start MongoDB service
/etc/init.d/mongod restart
