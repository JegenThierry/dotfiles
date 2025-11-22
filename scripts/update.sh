#!/bin/bash
# Exit on error
set -euo pipefail

# Ensure script is run as root, re-exec with sudo if not
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

echo "==> Updating System Packages"
apt update -y
apt upgrade -y

echo "==> Removing Unused Packages"
apt autoremove -y

echo "==> Updating Flatpak Packages"
flatpak update -y
