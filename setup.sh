#!/bin/bash

set -e

echo "[*] Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y

echo "[*] Installation des dépendances système pour le pare-feu Python..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    libnfnetlink-dev \
    libnetfilter-queue-dev \
    iptables \
    tcpdump

echo "Création d'un environnement virtuel Python (venv)..."
python3 -m venv firewall

echo "Activation de l'environnement virtuel..."
source firewall/bin/activate

echo "Mise à jour de pip..."
pip install --upgrade pip

echo "Installation des dépendances Python..."
pip install scapy netfilterqueue

echo "installation des dépendances reussi"
