#!/usr/bin/env bash

# ==============================================================================
# MASTER REALTEK RTL8822CE WI-FI RECOVERY & EDUCATIONAL SCRIPT
# ==============================================================================
#
# EDUCATIONAL GLOSSARY & DEVELOPER REFERENCE:
#
# 1. WHAT IS DKMS (Dynamic Kernel Module Support)?
#    - Framework that automatically compiles out-of-tree (third-party) drivers
#      whenever Linux updates its kernel version.
#
# 2. RTL8821CE vs RTL8822CE:
#    - RTL8821CE: Single-antenna (1x1) Realtek card.
#    - RTL8822CE: Dual-antenna (2x2) Realtek card (Your hardware ID: 10ec:c822).
#    - Loading an 8821CE driver onto an 8822CE card prevents initialization.
#
# 3. rtw_8822ce vs rtw88_8822ce:
#    - rtw_8822ce: Driver module name used by out-of-tree GitHub backports (lwfinger).
#    - rtw88_8822ce: Official, built-in driver module inside the Linux kernel.
#
# 4. WHAT IS modprobe AND ITS USE CASES?
#    - Tool used to add or remove driver modules from the running kernel.
#    - 'sudo modprobe <module>' loads a driver into active memory.
#    - 'sudo modprobe -r <module>' unloads a driver from active memory.
#
# 5. DIAGNOSTIC COMMAND FLAG BREAKDOWN:
#
#    A. lspci -nnk | grep -iA3 net
#       - lspci : Lists all devices on PCI/PCIe buses (Wi-Fi, Ethernet, GPU).
#       - -n    : Shows numerical Vendor/Device IDs (e.g., 10ec:c822).
#       - -nn   : Shows BOTH human-readable names AND numerical IDs.
#       - -k    : Displays active driver in use and available kernel modules.
#       - |     : Pipe operator; passes output to grep.
#       - grep  : Text search tool.
#       - -i    : Case-insensitive search (matches 'net', 'NET', 'Net').
#       - -A3   : "After 3" -> Prints the match plus 3 lines AFTER it.
#
#    B. grep -ir "rtw88" /etc/modprobe.d/
#       - -i    : Case-insensitive search.
#       - -r    : Recursive search (checks every file inside the directory).
#       - Purpose: Locates config files blacklisting the native driver.
#
#    C. sudo dmesg | grep -i rtw
#       - dmesg : Displays hardware boot logs and kernel status messages.
#       - grep -i rtw : Filters logs for Realtek driver initialization events/errors.
#
# ==============================================================================

# Helper function: Checks if a Wi-Fi interface is registered
check_wifi() {
    sleep 2
    if nmcli device 2>/dev/null | grep -qw "wifi"; then
        echo ""
        echo "======================================================================"
        echo "🎉 SUCCESS: Wi-Fi device detected and registered!"
        echo "======================================================================"
        nmcli device
        echo ""
        echo "Program exiting successfully."
        exit 0
    fi
}

echo "=== Initializing Wi-Fi Recovery Script ==="
check_wifi

# ------------------------------------------------------------------------------
# METHOD 1: Native Kernel Driver + PCIe Power Management Options (Fastest Fix)
# ------------------------------------------------------------------------------
echo ""
echo ">>> METHOD 1: Applying PCIe Power Management Fix to Native Driver..."

# Remove conflicting blacklists and custom configs
sudo rm -f /etc/modprobe.d/rtw88.conf
sudo rm -f /etc/modules-load.d/rtw88.conf

# Write PCIe stability options:
# - disable_lps_deep=y : Prevents non-responsive deep power sleep states.
# - disable_aspm=y     : Disables Active State Power Management on PCIe bus.
# - disable_msi=y      : Disables Message Signaled Interrupts to prevent bus locks.
sudo bash -c 'cat <<EOF > /etc/modprobe.d/rtw88.conf
options rtw88_core disable_lps_deep=y
options rtw88_pci disable_aspm=y
options rtw88_pci disable_msi=y
EOF'

# Reload module and network service
sudo modprobe -r rtw88_8822ce 2>/dev/null || true
sudo modprobe -r rtw_8822ce 2>/dev/null || true
sudo modprobe rtw88_8822ce 2>/dev/null || true
sudo systemctl restart NetworkManager

check_wifi
echo "Method 1 did not register a Wi-Fi device. Moving to Method 2..."

# ------------------------------------------------------------------------------
# METHOD 2: Reinstall Stock Firmware & Rebuild Boot Image
# ------------------------------------------------------------------------------
echo ""
echo ">>> METHOD 2: Reinstalling Linux Firmware & Updating Initramfs..."

sudo apt update -y
sudo apt install --reinstall -y linux-firmware build-essential
sudo depmod -a
sudo update-initramfs -u

sudo modprobe -r rtw88_8822ce 2>/dev/null || true
sudo modprobe rtw88_8822ce 2>/dev/null || true
sudo systemctl restart NetworkManager

check_wifi
echo "Method 2 did not register a Wi-Fi device. Moving to Method 3..."

# ------------------------------------------------------------------------------
# METHOD 3: Build & Install Maintained GitHub Driver (lwfinger/rtw88 via DKMS)
# ------------------------------------------------------------------------------
echo ""
echo ">>> METHOD 3: Building & Installing GitHub Backport Driver (lwfinger/rtw88)..."

# Install build tools
sudo apt install -y git dkms build-essential linux-headers-$(uname -r)

# Clean previous build folder if present
cd ~
rm -rf rtw88
git clone https://github.com/lwfinger/rtw88.git
cd rtw88

# Install driver via DKMS and install firmware files
sudo dkms install "$PWD" || true
sudo make install_fw || true
sudo cp -f rtw88.conf /etc/modprobe.d/ || true

sudo depmod -a
sudo update-initramfs -u

# Load backport driver module
sudo modprobe -r rtw_8822ce 2>/dev/null || true
sudo modprobe rtw_8822ce 2>/dev/null || true
sudo systemctl restart NetworkManager

check_wifi

# ------------------------------------------------------------------------------
# FALLBACK INSTRUCTIONS (If all methods failed to bring back Wi-Fi)
# ------------------------------------------------------------------------------
echo ""
echo "======================================================================"
echo "⚠️ ALL AUTOMATED METHODS EXHAUSTED AND WI-FI IS STILL ABSENT."
echo "======================================================================"
echo "This indicates a hardware register lock or Secure Boot key block."
echo ""
echo "STEP A: Cold Shutdown (Hardware Register Drain)"
echo "1. Shut down completely: sudo shutdown -h now"
echo "2. Unplug power charger cable for 15-20 seconds to drain motherboard residual power."
echo "3. Plug back in and turn on."
echo ""
echo "STEP B: Secure Boot Check"
echo "If Secure Boot is ENABLED in BIOS, custom DKMS drivers cannot load without key enrollment."
echo "Disable Secure Boot in BIOS/UEFI settings or enroll MOK key."
