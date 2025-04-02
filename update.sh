#!/bin/bash
#Exit on any error
set -e

if [ $EUID != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

echo "Updating System"
dnf update -y
dnf remove autoremove -y
dnf clean all -y

echo "Updating Flatpak"
flatpak update -y
