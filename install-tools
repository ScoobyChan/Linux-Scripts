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
1) General Tools ($general_tools)
2) Network Tools ($network_tools)
3) Setup Tools   ($setup_tools)
4) QEMU Tools    ($qemu_tools)
5) Quit"

read -p "Enter choices: " choices

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
$install $list
