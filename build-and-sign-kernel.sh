#!/bin/bash
set -e

## Co-pilot generated

########################################
### Detect Distro
########################################
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

DISTRO=$(detect_distro)
echo "[+] Detected distro: $DISTRO"

########################################
### Install Build Dependencies
########################################
install_deps() {
    case "$DISTRO" in
        arch)
            sudo pacman -Sy --needed base-devel bc openssl elfutils cpio perl tar xz mokutil pesign
            ;;
        debian|ubuntu)
            sudo apt update
            sudo apt install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev bc dwarves mokutil pesign
            ;;
        rhel|centos|fedora|rocky)
            sudo dnf groupinstall -y "Development Tools"
            sudo dnf install -y ncurses-devel bison flex elfutils-libelf-devel openssl-devel bc dwarves mokutil pesign
            ;;
        opensuse*)
            sudo zypper install -t pattern devel_basis
            sudo zypper install -y ncurses-devel libopenssl-devel libelf-devel flex bison bc dwarves mokutil pesign
            ;;
        *)
            echo "[-] Unsupported distro. Install build deps manually."
            ;;
    esac
}

echo "[+] Installing dependencies..."
install_deps

########################################
### Generate Secure Boot Keys
########################################
KEY_DIR="/root/kernel-keys"
PKI_DIR="/etc/pki/pesign"
KEY="$KEY_DIR/kernel-signing.key"
CRT="$KEY_DIR/kernel-signing.crt"
DER="$KEY_DIR/kernel-signing.der"

if [ ! -d "$KEY_DIR" ]; then
    echo "[+] Generating Secure Boot signing keys..."
    sudo mkdir -p "$KEY_DIR"
    sudo chmod 700 "$KEY_DIR"

    sudo openssl req -new -x509 -newkey rsa:4096 -sha256 -nodes \
        -keyout "$KEY" \
        -out "$CRT" \
        -subj "/CN=Custom Kernel Signing/" \
        -days 3650
    
    sudo openssl x509 -in $CRT -outform der -out $DER
    efikeygen --dbdir /etc/pki/pesign \
                --self-sign \
                --kernel \
                --module \
                --common-name 'CN=Organization signing key' \
                --nickname 'Custom Secure Boot key'

    certutil -d /etc/pki/pesign \
           -n 'Custom Secure Boot key' \
           -Lr \
           > sb_cert.cer

    echo "[+] Keys generated:"
    echo "    Private key: $KEY"
    echo "    Certificate: $CRT"
    echo "Der Certificate: $DER"
else
    echo "[+] Existing signing keys found in $KEY_DIR"
fi

########################################
### Enroll MOK Key
########################################
echo "[+] Enrolling MOK key..."
# sudo mokutil --import "$DER"
sudo mokutil --import sb_cert.cer

echo "[!] IMPORTANT: You MUST reboot and complete MOK enrollment in the blue screen."
echo "[!] After reboot, run this script again with:  --continue"
sleep 2

if [[ "$1" != "--continue" ]]; then
    echo "[+] Stopping here. Reboot now to enroll the key."
    exit 0
fi

########################################
### Get Latest Stable Kernel Version
########################################
echo "[+] Fetching latest stable kernel version..."
LATEST=$(curl -s https://www.kernel.org/ | grep -A1 "stable" | grep -oP '\d+\.\d+\.\d+' | sed -n '1p')

if [ -z "$LATEST" ]; then
    echo "[-] Could not detect latest kernel version."
    exit 1
fi

echo "[+] Latest stable kernel: $LATEST"

########################################
### Download Kernel Tarball
########################################
KERNEL_URL="https://cdn.kernel.org/pub/linux/kernel/v${LATEST%%.*}.x/linux-$LATEST.tar.xz"

echo "[+] Downloading kernel: $KERNEL_URL"
curl -LO "$KERNEL_URL"

echo "[+] Extracting kernel..."
tar -xf "linux-$LATEST.tar.xz"
cd "linux-$LATEST"

########################################
### Kernel Configuration
########################################
echo "[+] Preparing kernel config..."

if [ -f /boot/config-$(uname -r) ]; then
    echo "[+] Using current kernel config as base"
    cp /boot/config-$(uname -r) .config
    yes "" | make oldconfig
else
    echo "[+] No existing config found, using defaults"
    make defconfig
fi

########################################
### Compile Kernel
########################################
echo "[+] Compiling kernel..."
make -j"$(nproc)"

########################################
### Install Modules
########################################
echo "[+] Installing modules..."
sudo make modules_install

########################################
### Sign All Kernel Modules
########################################
echo "[+] Signing kernel modules..."
MOD_DIR="/lib/modules/$LATEST"

for mod in $(find "$MOD_DIR" -type f -name "*.ko"); do
    sudo /usr/src/kernels/$(uname -r)/scripts/sign-file sha512 "$KEY" "$CRT" "$mod"
done

########################################
### Install Kernel
########################################
echo "[+] Installing kernel..."
sudo make install

########################################
### Sign Kernel EFI Binary
########################################
EFI_KERNEL=$(ls /boot/vmlinuz-$LATEST* | head -n1)

echo "[+] Signing kernel EFI binary: $EFI_KERNEL"
certutil -A -d /root/kernel-keys -n "kernel-signing" -t "C,," -i /root/kernel-keys/kernel-signing.crt
pesign --certificate 'Custom Secure Boot key' \
         --in $EFI_KERNEL\
         --sign \
         --out "$EFI_KERNEL.signed" \
         --force

# sudo pesign -s -i "$EFI_KERNEL" -o "$EFI_KERNEL.signed" -c "$KEY"

sudo mv "$EFI_KERNEL.signed" "$EFI_KERNEL"

########################################
### Update Bootloader
########################################
echo "[+] Updating bootloader..."

if command -v update-grub >/dev/null 2>&1; then
    sudo update-grub
elif command -v grub-mkconfig >/dev/null 2>&1; then
    sudo grub-mkconfig -o /boot/grub/grub.cfg
else
    echo "[!] Could not detect GRUB update command. Update manually."
fi

echo "[+] Kernel $LATEST built, signed, and installed successfully!"
echo "[+] Reboot to use the new Secure Boot–signed kernel."
