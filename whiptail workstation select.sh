#!/bin/bash
# Auto-detect Linux distro and run the correct workstation setup

install=$(bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/pack_mgr_install.sh | sh | grep sudo")
$install make

# Detect OS
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO_ID=$ID
    DISTRO_LIKE=$ID_LIKE
else
    echo "Cannot detect OS (missing /etc/os-release)"
    exit 1
fi

echo "Detected OS: $DISTRO_ID"

case "$DISTRO_ID" in
    arch|artix)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-arch.sh | sh"
        ;;

    debian|ubuntu|linuxmint|pop|zorin)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-deb.sh | sh"
        ;;

    opensuse*|suse|sles)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-opensuse.sh | sh"
        ;;

    rhel|centos|rocky|almalinux|fedora)
        bash -c "curl -fsSL https://raw.githubusercontent.com/ScoobyChan/Linux-Scripts/refs/heads/main/workstation-rhel.sh | sh"
        ;;

    *)
        echo "Unsupported or unknown distro: $DISTRO_ID"
        echo "ID_LIKE: $DISTRO_LIKE"
        exit 1
        ;;
esac
