#!/bin/bash
# Exit on error
set -euo pipefail

# Ensure script is run as root, re-exec with sudo if not
if [[ $EUID -ne 0 ]]; then
    exec sudo "$0" "$@"
fi

echo "==> Updating System Packages"
dnf upgrade --refresh -y

echo "==> Removing Unused Packages"
dnf remove autoremove -y

echo "==> Cleaning Up DNF Cache"
dnf clean all -y

echo "==> Updating Flatpak Packages"
flatpak update -y
