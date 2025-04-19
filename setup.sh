#!/bin/bash

# Vérifier que le script est exécuté avec sudo
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script avec sudo."
    exit 1
fi

set -e

echo "Mise à jour des paquets..."
apt update && apt upgrade -y

echo "Installation des dépendances système..."
apt install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    libnfnetlink-dev \
    libnetfilter-queue-dev \
    iptables \
    tcpdump

echo "Installation des bibliothèques Python globalement..."
pip3 install --upgrade pip
pip3 install scapy netfilterqueue --break-system-packages

echo "Déploiement du service systemd..."

SERVICE_PATH="/etc/systemd/system/firewall.service"
PROJECT_PATH="$(pwd)/firewall.service"

if [ ! -f "$PROJECT_PATH" ]; then
    echo "Le fichier firewall.service est introuvable dans le projet."
    exit 1
fi

ln -sf "$PROJECT_PATH" "$SERVICE_PATH"

echo "Rechargement de systemd..."
systemctl daemon-reexec
systemctl daemon-reload

echo "Activation du service firewall..."
systemctl enable firewall
systemctl restart firewall

# Vérifie que le service tourne avant de toucher aux paquets
if systemctl is-active --quiet firewall; then
    echo "Application de la règle iptables (NFQUEUE)..."
    iptables -I INPUT -j NFQUEUE --queue-num 1
else
    echo "Le service ne fonctionne pas, la règle iptables n’a pas été appliquée."
    systemctl status firewall --no-pager
    exit 1
fi

echo "Installation et démarrage terminés !"
