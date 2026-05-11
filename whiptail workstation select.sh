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
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-arch.sh | sh"
        ;;
    1)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-deb.sh | sh"
        ;;
    2)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-opensuse.sh | sh"
        ;;
    4)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-rhel.sh | sh"
        ;;
    5)
        exit 0
        ;;
esac