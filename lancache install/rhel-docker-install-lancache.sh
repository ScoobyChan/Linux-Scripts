# https://docs.docker.com/engine/install/rhel/
# https://github.com/Shuffle/Shuffle/blob/main/.github/install-guide.md

sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo -y
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

useradd -r svc_lancache -m -d /usr/lancache -s /bin/bash -c "Lancache Service account"
su -c "cd /usr/lancache && git clone https://github.com/lancachenet/docker-compose/ lancache --depth=1 && chown -R svc_lancache:svc_lancache /usr/lancache/ && cd lancache && curl -O https://raw.githubusercontent.com/lancachenet/docker-compose/main/docker-compose.yml > .env" - svc_lancache

su -c "sudo swapoff -a && sudo usermod -aG docker svc_lancache && systemctl enable docker --now" - root

su -c "cd /usr/lancache/lancache && docker compose up -d" - svc_lancache