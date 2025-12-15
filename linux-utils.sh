#!/usr/bin/env bash

echo "Installing useful Linux command shortcuts..."

# Ensure bashrc exists
BASHRC="$HOME/.bashrc"

# Disk usage (sorted)
cat << 'EOF' >> "$BASHRC"

# === Disk Usage Helpers ===
duh() {
    du -h --max-depth=1 "$@" 2>/dev/null | sort -hr
}

# Show largest files
bigfiles() {
    find . -type f -exec du -h {} + | sort -hr | head -20
}

# Memory usage
memtop() {
    ps aux --sort=-%mem | head -15
}

# CPU usage
cputop() {
    ps aux --sort=-%cpu | head -15
}

# Network ports
ports() {
    sudo ss -tulpn
}

EOF

echo "Utilities added. Reload terminal or run:"
echo "source ~/.bashrc"
