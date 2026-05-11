#!/bin/bash
install=$(bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/pack_mgr_install.sh | sh | grep sudo")

general_tools="vim python3"
network_tools="nmap iptables"
setup_tools="git curl"
qemu_tools="qemu qemu-img python3 python3-pip virt-manager"

CHOICES=$(whiptail --title "Package Installer" --checklist \
"Select package groups to install:" 20 60 10 \
"general" "General Tools" OFF \
"network" "Network Tools" OFF \
"setup" "Setup Tools" OFF \
"qemu" "QEMU Tools" OFF \
3>&1 1>&2 2>&3)

# Convert whiptail output into usable list
INSTALL_LIST=""

for choice in $CHOICES; do
    case $choice in
        "\"general\"")
            INSTALL_LIST="$INSTALL_LIST $general_tools"
            ;;
        "\"network\"")
            INSTALL_LIST="$INSTALL_LIST $network_tools"
            ;;
        "\"setup\"")
            INSTALL_LIST="$INSTALL_LIST $setup_tools"
            ;;
        "\"qemu\"")
            INSTALL_LIST="$INSTALL_LIST $qemu_tools"
            ;;
    esac
done

# Run installer
[ -n "$INSTALL_LIST" ] && $install $INSTALL_LIST
