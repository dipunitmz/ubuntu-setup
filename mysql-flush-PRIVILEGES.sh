#!/bin/bash

# Stop MySQL service
sudo systemctl stop mysql

# Create socket directory if missing
sudo mkdir -p /var/run/mysqld

# Set correct ownership and permissions
sudo chown mysql:mysql /var/run/mysqld
sudo chmod 755 /var/run/mysqld

# Start MySQL in safe mode (no password, no networking)
sudo mysqld_safe --skip-grant-tables --skip-networking &

# Wait for MySQL to start
sleep 5

# Clear root authentication (MySQL 8+)
mysql -u root <<EOF
UPDATE mysql.user
SET plugin='mysql_native_password',
    authentication_string=''
WHERE user='root' AND host='localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Stop safe-mode MySQL
sudo systemctl stop mysql

# Start MySQL normally
sudo systemctl start mysql

# Set new root password (change root123 if needed)
mysql -u root <<EOF
ALTER USER 'root'@'localhost'
IDENTIFIED WITH mysql_native_password BY 'root123';
FLUSH PRIVILEGES;
EXIT;
EOF

# Test login
mysql -u root -p
