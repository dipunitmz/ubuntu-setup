#!/bin/bash

### FULL AUTOMATED MYSQL + WORKBENCH SETUP FOR UBUNTU ###

# Must run as root
if [ "$(id -u)" != "0" ]; then
   echo "Run this script with sudo"
   exit 1
fi

MYSQL_ROOT_PASSWORD="root123"   # <-- SET YOUR PASSWORD HERE

echo "Updating system..."
apt update && apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Error updating packages."
    exit 1
fi

echo "Installing MySQL Server..."
apt install mysql-server -y
if [ $? -ne 0 ]; then
    echo "Error installing MySQL Server."
    exit 1
fi

echo "Starting & enabling MySQL..."
systemctl start mysql
systemctl enable mysql

echo "Configuring MySQL root password..."
# Login without password (auth_socket mode)
mysql --user=root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

if [ $? -ne 0 ]; then
    echo "Error setting root password."
    exit 1
fi

echo "Securing MySQL installation..."
mysql --user=root --password="${MYSQL_ROOT_PASSWORD}" <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

echo "Installing snapd..."
apt install snapd -y

echo "Installing MySQL Workbench (Snap)..."
snap install mysql-workbench-community

echo ""
echo "###########################################################"
echo " MySQL + Workbench Installation Completed Successfully!"
echo ""
echo " MySQL Root Username : root"
echo " MySQL Root Password : ${MYSQL_ROOT_PASSWORD}"
echo ""
echo " To open Workbench, run: mysql-workbench-community"
echo ""
echo "###########################################################"
