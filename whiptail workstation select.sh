# !/bin/bash
# This script provides a menu for selecting which workstation setup to install packages for.

whiptail --title "Workstation Setup" --menu "Select an option:" 15 50 4 \
    "1" "Install Arch Linux packages" \
    "2" "Install Debian packages" \
    "3" "Install openSUSE packages" \
    "4" "Install RHEL packages" \
    "5" "Exit"

CHOICE=$?

case $CHOICE in
    0)
        bash workstation-arch.sh
        ;;
    1)
        bash workstation-deb.sh
        ;;
    2)
        bash workstation-opensuse.sh
        ;;
    4)
        bash workstation-rhel.sh
        ;;
    5)
        exit 0
        ;;
esac