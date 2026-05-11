#!/bin/bash
install=$(bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/pack_mgr_install.sh | sh | grep sudo")

############################
### Package Installation ###
############################
# Packages
general_tools="vim python3"
network_tools="nmap iptables"
setup_tools="git wget curl"
qemu_tools="qemu qemu-img python3 python3-pip virt-manager"

# $install $general_tools $network_tools $setup_tools $qemu_tools

#!/bin/bash

echo "Select packages to install (space separated):
1) General Tools
2) Network Tools
3) Setup Tools
4) QEMU Tools
5) Quit"

read -p "Enter choices (eg 2 4): " choices

for c in $choices; do
    case $c in
        1) list="$list $general_tools" ;;
        2) list="$list $network_tools" ;;
        3) list="$list $setup_tools" ;;
        4) list="$list $qemu_tools" ;;
        5) exit 0 ;;
        *) echo "Invalid option: $c" ;;
    esac
done

echo "Installing: $list"
