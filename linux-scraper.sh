#!/bin/bash

set -e

APP_DIR="/opt/linux-tracker"
USER_NAME="$(whoami)"

echo "[*] Creating app directory..."
sudo mkdir -p $APP_DIR
sudo chown $USER_NAME:$USER_NAME $APP_DIR

cd $APP_DIR

echo "[*] Installing system packages..."
sudo dnf install -y python3 python3-pip aria2 git gcc python3-devel

echo "[*] Installing Python dependencies..."
pip3 install flask sqlalchemy requests beautifulsoup4 psycopg2-binary

echo "[*] Creating project structure..."
mkdir -p templates static

dnf install -y postgresql-server postgresql-contrib postgresql-devel
dnf install -y ufw

##############################
# config.py
##############################
cat <<EOF > config.py
import os
DB_URL = os.getenv("DATABASE_URL", "sqlite:///tracker.db")
EOF

##############################
# db.py
##############################
cat <<EOF > db.py
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from config import DB_URL

engine = create_engine(DB_URL, echo=False)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()
EOF

##############################
# models.py
##############################
cat <<EOF > models.py
from sqlalchemy import Column, Integer, String, DateTime
from datetime import datetime
from db import Base

class Torrent(Base):
    __tablename__ = "torrents"
    id = Column(Integer, primary_key=True)
    name = Column(String)
    url = Column(String, unique=True)
    distro = Column(String)
    added_at = Column(DateTime, default=datetime.utcnow)

class TorrentStats(Base):
    __tablename__ = "torrent_stats"
    id = Column(Integer, primary_key=True)
    name = Column(String)
    seeders = Column(Integer)
    peers = Column(Integer)
    speed = Column(String)
    updated_at = Column(DateTime, default=datetime.utcnow)
EOF

##############################
# tracker.py
##############################
cat <<'EOF' > tracker.py
import requests
from bs4 import BeautifulSoup
from db import SessionLocal
from models import Torrent, TorrentStats
import time

ARIA2_RPC = "http://localhost:6800/jsonrpc"

# ✅ Tier 1–3 built-in torrent sources
STATIC_TORRENTS = {
    "ubuntu": "https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso.torrent",
    "debian": "https://cdimage.debian.org/debian-cd/current/amd64/bt-dvd/debian-amd64-DVD-1.iso.torrent",
    "fedora": "https://torrent.fedoraproject.org/torrents/Fedora-Workstation-Live-x86_64.torrent",
    "arch": "https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso.torrent",
    "manjaro": "https://download.manjaro.org/kde/latest/manjaro-kde.iso.torrent",
    "linuxmint": "https://mirrors.edge.kernel.org/linuxmint/stable/21.3/linuxmint-21.3-cinnamon-64bit.iso.torrent",
    "mxlinux": "https://sourceforge.net/projects/mx-linux/files/latest/download",
    "popos": "https://iso.pop-os.org/latest/pop-os.iso.torrent",
    "zorin": "https://sourceforge.net/projects/zorin-os/files/latest/download",
    "elementary": "https://sourceforge.net/projects/elementaryos/files/latest/download",

    # Tier 2–3
    "kali": "https://cdimage.kali.org/current/kali-linux-amd64.iso.torrent",
    "tails": "https://mirrors.edge.kernel.org/tails/stable/tails-amd64.iso.torrent",
    "parrot": "https://deb.parrot.sh/parrot/iso/parrot.iso.torrent",
    "garuda": "https://iso.builds.garudalinux.org/iso/latest/garuda.iso.torrent",
    "nitrux": "https://sourceforge.net/projects/nitruxos/files/latest/download",
    "sparky": "https://sourceforge.net/projects/sparkylinux/files/latest/download"
}

# ✅ Distros to match during scraping
TRACKED_DISTROS = list(STATIC_TORRENTS.keys())

LINUXTRACKER_URL = "https://linuxtracker.org/index.php?page=torrents"

# -----------------------------
# DB SAVE
# -----------------------------
def save_torrent(name, url, distro):
    db = SessionLocal()

    if db.query(Torrent).filter_by(url=url).first():
        db.close()
        return False

    t = Torrent(name=name, url=url, distro=distro)
    db.add(t)
    db.commit()
    db.close()

    return True

# -----------------------------
# STATIC SOURCES INGESTION
# -----------------------------
def ingest_static_sources():
    print("[*] Ingesting static torrents...")

    for distro, url in STATIC_TORRENTS.items():
        name = f"{distro} official torrent"

        if save_torrent(name, url, distro):
            print(f"[+] Added static: {distro}")
            download_torrent(url)

# -----------------------------
# SCRAPER
# -----------------------------
def scrape_linuxtracker():
    print("[*] Scraping LinuxTracker...")

    try:
        r = requests.get(LINUXTRACKER_URL, timeout=10)
        soup = BeautifulSoup(r.text, "html.parser")
    except Exception as e:
        print(f"[!] scrape failed: {e}")
        return []

    torrents = []

    for row in soup.find_all("tr"):
        links = row.find_all("a")

        for link in links:
            href = link.get("href", "")
            name = link.text.strip().lower()

            if "torrent" in href and "iso" in name:
                full_url = "https://linuxtracker.org/" + href if not href.startswith("http") else href

                torrents.append({
                    "name": name,
                    "url": full_url
                })

    return torrents

# -----------------------------
# MATCH + DOWNLOAD
# -----------------------------
def download_torrent(url):
    payload = {
        "jsonrpc": "2.0",
        "id": "add",
        "method": "aria2.addUri",
        "params": [[url]]
    }
    try:
        requests.post(ARIA2_RPC, json=payload)
    except:
        pass


def match_and_download(torrents):
    print("[*] Matching scraped torrents...")

    count = 0
    MAX_PER_RUN = 10

    for t in torrents:
        if count >= MAX_PER_RUN:
            break

        for distro in TRACKED_DISTROS:
            if distro in t["name"]:

                if save_torrent(t["name"], t["url"], distro):
                    print(f"[+] New: {t['name']}")
                    download_torrent(t["url"])
                    count += 1

# -----------------------------
# STATS
# -----------------------------
def get_stats():
    payload = {
        "jsonrpc": "2.0",
        "id": "stats",
        "method": "aria2.tellActive"
    }

    try:
        r = requests.post(ARIA2_RPC, json=payload)
        data = r.json().get("result", [])
    except:
        return []

    stats = []

    for d in data:
        stats.append({
            "name": d.get("bittorrent", {}).get("info", {}).get("name", "unknown"),
            "seeders": int(d.get("numSeeders", 0)),
            "peers": int(d.get("connections", 0)),
            "speed": d.get("downloadSpeed", "0")
        })

    return stats

def store_stats(stats):
    db = SessionLocal()

    for s in stats:
        db.add(TorrentStats(
            name=s["name"],
            seeders=s["seeders"],
            peers=s["peers"],
            speed=s["speed"]
        ))

    db.commit()
    db.close()

# -----------------------------
# FULL SCAN (IMPORTANT)
# -----------------------------
def full_run():
    ingest_static_sources()

    torrents = scrape_linuxtracker()
    match_and_download(torrents)

    stats = get_stats()
    store_stats(stats)
EOF

##############################
# app.py
##############################
cat <<'EOF' > app.py
from flask import Flask, render_template
from db import SessionLocal
from models import Torrent, TorrentStats

app = Flask(__name__)

@app.route("/")
def index():
    db = SessionLocal()

    torrents = db.query(Torrent).order_by(Torrent.added_at.desc()).limit(50)
    stats = db.query(TorrentStats).order_by(TorrentStats.updated_at.desc()).limit(50)

    return render_template("index.html", torrents=torrents, stats=stats)

app.run(host="0.0.0.0", port=5000)
EOF

##############################
# worker.py
##############################
cat <<'EOF' > worker.py
import time
import tracker

while True:
    print("[*] Running full pipeline...")

    tracker.full_run()

    time.sleep(600)
EOF

##############################
# HTML
##############################
cat <<EOF > templates/index.html
<!DOCTYPE html>
<head>
<title>Linux Tracker</title>

<style>
body {
font-family: system-ui, Arial;
background: #0d1117;
color: #e6edf3;
margin: 0;
}

header {
padding: 20px;
background: #161b22;
border-bottom: 1px solid #30363d;
font-size: 24px;
}

.container {
padding: 20px;
}

input {
padding: 10px;
width: 300px;
margin-bottom: 15px;
border-radius: 8px;
border: 1px solid #30363d;
background: #0d1117;
color: white;
}

button {
padding: 10px 15px;
margin-left: 10px;
border-radius: 8px;
border: none;
background: #238636;
color: white;
cursor: pointer;
}

.grid {
display: grid;
grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
gap: 15px;
}

.card {
background: #161b22;
padding: 15px;
border-radius: 16px;
border: 1px solid #30363d;
box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}

.title {
font-size: 14px;
font-weight: bold;
}

.distro {
color: #58a6ff;
font-size: 13px;
}

.badge {
padding: 3px 8px;
border-radius: 8px;
font-size: 12px;
}

.good { background: #238636; }
.ok { background: #d29922; }
.bad { background: #da3633; }

.stats {
margin-top: 10px;
font-size: 13px;
display: flex;
justify-content: space-between;
}

.footer {
margin-top: 10px;
font-size: 11px;
color: #8b949e;
}
</style>
</head>

<body>

<header>
🐧 Linux Torrent Dashboard
</header>

<div class="container">

<input id="search" placeholder="Search distro...">

<button onclick="refresh()">🔄 Refresh</button>
<button onclick="sortBySeeders()">⬆ Sort by Seeders</button>

<h2>📦 Torrents</h2>

<div class="grid" id="torrentGrid">

{% for t in torrents %}
<div class="card" data-name="{{ t.name.lower() }}">
<div class="title">{{ t.name }}</div>
<div class="distro">{{ t.distro }}</div>

<div class="footer">
    Added: {{ t.added_at }}
</div>
</div>
{% endfor %}

</div>

<h2>📊 Live Stats</h2>

<div class="grid" id="statsGrid">

{% for s in stats %}
<div class="card stat-card" data-seeders="{{ s.seeders }}">

<div class="title">{{ s.name }}</div>

<div class="stats">
    <div>🌱 {{ s.seeders }} seeders</div>
    <div>👥 {{ s.peers }} peers</div>
    <div>⚡ {{ s.speed }}</div>
</div>

<div>
    {% if s.seeders > 50 %}
        <span class="badge good">Healthy</span>
    {% elif s.seeders > 10 %}
        <span class="badge ok">Moderate</span>
    {% else %}
        <span class="badge bad">Poor</span>
    {% endif %}
</div>

</div>
{% endfor %}

</div>

</div>

<script>
function refresh() {
location.reload();
}

document.getElementById("search").addEventListener("keyup", function () {
let val = this.value.toLowerCase();

document.querySelectorAll("#torrentGrid .card").forEach(card => {
let name = card.getAttribute("data-name");
card.style.display = name.includes(val) ? "block" : "none";
});
});

function sortBySeeders() {
let grid = document.getElementById("statsGrid");
let cards = Array.from(grid.children);

cards.sort((a, b) => {
return b.dataset.seeders - a.dataset.seeders;
});

grid.innerHTML = "";
cards.forEach(c => grid.appendChild(c));
}
</script>

</body>
</html>
EOF

##############################
# Initialize DB
##############################
python3 - <<EOF
from db import engine
from models import Base
Base.metadata.create_all(bind=engine)
EOF

##############################
# systemd services
##############################
echo "[*] Creating systemd services..."

sudo bash -c "cat > /etc/systemd/system/linux-tracker.service" <<EOF
[Unit]
Description=Linux Tracker Web
After=network.target

[Service]
User=$USER_NAME
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/python3 $APP_DIR/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo bash -c "cat > /etc/systemd/system/linux-tracker-worker.service" <<EOF
[Unit]
Description=Linux Tracker Worker

[Service]
User=$USER_NAME
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/python3 $APP_DIR/worker.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

##############################
# Enable firewall
##############################
sudo ufw allow ssh
sudo ufw allow 5000/tcp
sudo ufw enable
sudo ufw default deny incoming
sudo ufw status
sudo ufw reload

##############################
# Start aria2 RPC
##############################
nohup aria2c --enable-rpc --rpc-listen-all=true --rpc-allow-origin-all &

##############################
# Enable services
##############################
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable --now linux-tracker
sudo systemctl enable --now linux-tracker-worker

sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql

sudo -u postgres createuser tracker
sudo -u postgres createdb linuxtracker

export DATABASE_URL=postgresql://tracker@localhost/linuxtracker
systemctl restart linux-tracker

echo "✅ INSTALL COMPLETE"
echo "Open: http://YOUR-SERVER-IP:5000"