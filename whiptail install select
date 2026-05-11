#!/bin/bash
# Workstation Setup Menu

install=$(bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/pack_mgr_install.sh | sh | grep sudo")
$install make

CHOICE=$(whiptail --title "Workstation Setup" --menu "Select an option:" 15 50 6 \
    "1" "Install Arch Linux packages" \
    "2" "Install Debian packages" \
    "3" "Install openSUSE packages" \
    "4" "Install RHEL packages" \
    "5" "Exit" \
    3>&1 1>&2 2>&3)

exitstatus=$?

if [[ $exitstatus -ne 0 ]]; then
    echo "User cancelled."
    exit 1
fi

case $CHOICE in
    1)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-arch.sh | sh"
        ;;
    2)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-deb.sh | sh"
        ;;
    3)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-opensuse.sh | sh"
        ;;
    4)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-rhel.sh | sh"
        ;;
    5)
        exit 0
        ;;
esac
