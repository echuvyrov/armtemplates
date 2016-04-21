#!/bin/bash

if [ -e "DgSecure-linux-x64-sn-installer.run" ] 
then
  echo "DgSecure setup already exists, skipping download"
else
  echo "Downloading DgSecure binaries"
  wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/5131/DgSecure-5.1.3.1-linux-x64-sn-installer.run -O DgSecure-5.1.3.1-linux-x64-sn-installer.run
fi

wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/5131/InstallDgSecureSN.sh -O InstallDgSecureSN.sh

chmod +x InstallDgSecureSN.sh
chmod +x DgSecure-5.1.3.1-linux-x64-sn-installer.run

if which java >/dev/null 2>&1 ; then
  echo "Java installation found, skipping Java install."
else
  echo "Java not found. Downloading and installing Java."
  echo "\n" | sudo add-apt-repository ppa:webupd8team/java
  sudo apt-get update
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
  sudo apt-get -y install oracle-java7-installer
  sudo apt-get install oracle-java7-set-default

fi

echo "Creating /var/lock/subsys directory"
sudo mkdir /var/lock/subsys 

echo "Installing DgSecure.."
sudo sh InstallDgSecureSN.sh
echo "DgSecure Installation finished."

echo "Installing license"
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/license/dgdump_build5.1.3.1.tar.gz -O /tmp/dgdump_build5.1.3.1.tar.gz
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/license/runrestore.sh -O /tmp/runrestore.sh
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/license/updatelic.sh -O /tmp/updatelic.sh
chmod +x /tmp/runrestore.sh
chmod +x /tmp/updatelic.sh
sudo sh /tmp/runrestore.sh
sudo sh /tmp/updatelic.sh

echo "Restarting tomcat"
sudo sh /opt/Dataguise/DgSecure/tomcat7/stop.sh
sleep 10
sudo sh /opt/Dataguise/DgSecure/tomcat7/start.sh

echo "Create SQL Server connection"
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/ConnectionMgr/connection.sh -O /tmp/connection.sh
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/ConnectionMgr/connection_dgcl.txt -O /tmp/connection_dgcl.txt
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/ConnectionMgr/connection_discover_string.xml -O /tmp/connection_discover_string.xml
wget https://s3.amazonaws.com/dgsecure/sqlserveronazure/ConnectionMgr/connection_masker_string.xml -O /tmp/connection_masker_string.xml

chmod +x /tmp/connection.sh
chmod +x /tmp/connection_dgcl.txt
chmod +x /tmp/connection_discover_string.xml
chmod +x /tmp/connection_masker_string.xml

echo "value of parameter"$1
echo "executing connection manager script"
sudo sh /tmp/connection.sh $1
echo "Connection manager added"
echo "All Done."