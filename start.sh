#!/bin/bash

set -e

# Active l'environnement virtuel
echo "Activation de l'environnement virtuel..."
source firewall/bin/activate

# Lancer le pare-feu en arrière-plan
echo "Démarrage du pare-feu..."
python firewall.py &
FW_PID=$!

# fix du racing condition
sleep 2

# Ajouter la règle iptables
echo "Ajout de la règle iptables..."
sudo iptables -I INPUT -j NFQUEUE --queue-num 1

echo "Pare-feu actif (PID: $FW_PID)."
echo "Pour arrêter : 'sudo iptables -D INPUT -j NFQUEUE --queue-num 1' puis tuer le processus $FW_PID"
