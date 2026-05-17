useradd -r svc_wazuh -m -d /usr/wazuh -s /bin/bash -c "Wazuh Service account"
# usermod -aG wheel svc_wazuh
dnf install tar curl openssl -y
su -c "

cd /usr/wazuh

curl -sO https://packages.wazuh.com/4.14/wazuh-certs-tool.sh
curl -sO https://packages.wazuh.com/4.14/config.yml

Index_IP_Address=$(hostname -I | awk '{print $1}')
read -p "Enter the IP address of the Wazuh Server: " Server_IP_Address
read -p "Enter the IP address of the Wazuh Dashboard: " Dashboard_IP_Address

sed -i "s/<indexer-node-ip>/$Index_IP_Address/g" config.yml
sed -i "s/<wazuh-manager-ip>/$Server_IP_Address/g" config.yml
sed -i "s/<dashboard-node-ip>/$Dashboard_IP_Address/g" config.yml

bash ./wazuh-certs-tool.sh -A

tar -cvf ./wazuh-certificates.tar -C ./wazuh-certificates/ .
rm -rf ./wazuh-certificates
" - svc_wazuh

dnf install coreutils
rpm --import https://packages.wazuh.com/key/GPG-KEY-WAZUH
echo -e '[wazuh]\ngpgcheck=1\ngpgkey=https://packages.wazuh.com/key/GPG-KEY-WAZUH\nenabled=1\nname=EL-$releasever - Wazuh\nbaseurl=https://packages.wazuh.com/4.x/yum/\npriority=1' | tee /etc/yum.repos.d/wazuh.repo

dnf -y install wazuh-indexer



usermod -G wheel -d /usr/wazuh svc_wazuh