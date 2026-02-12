#!/bin/bash

# ============================================================
# MySQL Emergency Recovery Helper
# Fixes common issues:
#   - Permission problems
#   - Missing socket directory
#   - Stale mysqld processes
#   - Starting MySQL safely
#
# DOES NOT change password automatically (safer)
# It prepares environment so you can reset it manually.
# ============================================================

echo "========== MySQL Recovery Script =========="

# Stop mysql service
echo "[1] Stopping MySQL service..."
sudo systemctl stop mysql

# Kill any leftover mysqld processes
echo "[2] Killing stale mysqld processes..."
sudo pkill -9 mysqld 2>/dev/null

# Ensure runtime socket directory exists
echo "[3] Creating socket directory..."
sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld
sudo chmod 755 /var/run/mysqld

# Fix ownership of data directory
echo "[4] Fixing data directory permissions..."
sudo chown -R mysql:mysql /var/lib/mysql

# Remove stale socket/pid files
echo "[5] Cleaning old socket/pid files..."
sudo rm -f /var/run/mysqld/mysqld.sock
sudo rm -f /var/run/mysqld/mysqld.pid

echo ""
echo "=============================================="
echo "Environment prepared."
echo ""
echo "To reset password:"
echo "1️⃣ Start recovery mode:"
echo "   sudo mysqld_safe --skip-grant-tables --skip-networking &"
echo ""
echo "2️⃣ Login:"
echo "   mysql -u root"
echo ""
echo "3️⃣ Inside MySQL run:"
echo "   FLUSH PRIVILEGES;"
echo "   ALTER USER 'root'@'localhost' IDENTIFIED BY 'NEWPASS';"
echo ""
echo "4️⃣ Restart normally:"
echo "   sudo pkill mysqld"
echo "   sudo systemctl start mysql"
echo "=============================================="
