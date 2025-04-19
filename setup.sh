#!/bin/bash

# verifier que le script est exécuté avec les droits root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script avec sudo."
    exit 1;
fi

set -e

echo "[*] Mise à jour des paquets..."
apt update && apt upgrade -y

echo "[*] Installation des dépendances système pour le pare-feu Python..."
apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    libnfnetlink-dev \
    libnetfilter-queue-dev \
    iptables \
    tcpdump

echo "[*] Création d'un environnement virtuel Python (venv)..."
python3 -m venv firewall

echo "[*] Activation de l'environnement virtuel..."
source firewall/bin/activate

echo "[*] Mise à jour de pip..."
pip install --upgrade pip

echo "[*] Installation des dépendances Python..."
pip install scapy netfilterqueue

echo "[*] Création et activation du service systemd..."

SERVICE_PATH="/etc/systemd/system/firewall.service"
PROJECT_PATH="$(pwd)/firewall.service"

if [ ! -f "$PROJECT_PATH" ]; then
    echo "[!] Le fichier firewall.service est introuvable dans le projet."
    exit 1
fi

echo "→ Lien symbolique vers systemd..."
ln -sf "$PROJECT_PATH" "$SERVICE_PATH"

echo "→ Rechargement du démon systemd..."
systemctl daemon-reexec
systemctl daemon-reload

echo "→ Activation du service firewall..."
systemctl enable firewall

echo "→ Démarrage du service firewall..."
systemctl start firewall

echo "→ Statut du pare-feu :"
systemctl status firewall --no-pager
