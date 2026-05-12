# https://docs.docker.com/engine/install/rhel/
# https://github.com/Shuffle/Shuffle/blob/main/.github/install-guide.md

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo -y
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

useradd -r svc_shuffle -m -d /usr/shuffle -s /bin/bash -c "Shuffle Service account"
su -c "cd /usr/shuffle && git clone https://github.com/Shuffle/Shuffle && chown -R svc_shuffle:svc_shuffle /usr/shuffle/ && cd Shuffle" - svc_shuffle

su -c "sudo swapoff -a && sudo sysctl -w vm.max_map_count=262144 && sudo usermod -aG docker svc_shuffle" - root

su -c "cd /usr/shuffle/Shuffle && docker compose up -d" - svc_shuffle
