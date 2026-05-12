# https://docs.docker.com/engine/install/rhel/
# https://github.com/Shuffle/Shuffle/blob/main/.github/install-guide.md

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

useradd -r svc_shuffle -m -d /usr/shuffle -s /bin/bash -c "Shuffle Service account"
su -c "git clone https://github.com/Shuffle/Shuffle
cd Shuffle" svc_shuffle

su -c "
sudo swapoff -a
sudo sysctl -w vm.max_map_count=262144
sudo usermod -aG docker svc_shuffle
" root
docker compose up -d
