#!/bin/bash
set -e  # Arrêter le script en cas d'erreur

# Crée un environnement virtuel
echo "[*] Création de l'environnement virtuel Python..."
python3 -m venv firewall

# Active l'environnement virtuel
source firewall/bin/activate

# Met à jour pip
echo "[*] Mise à jour de pip..."
pip install --upgrade pip

# Installe les dépendances
echo "[*] Installation des dépendances depuis requirements.txt..."
pip install -r requirements.txt

# Ajoute une règle iptables pour rediriger les paquets vers NFQUEUE
echo "[*] Ajout de la règle iptables..."
sudo iptables -I INPUT -j NFQUEUE --queue-num 1

echo "Configuration terminée. Vous pouvez maintenant exécuter firewall.py"
