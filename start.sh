#!/bin/bash

set -e

# Active l'environnement virtuel
echo "Activation de l'environnement virtuel..."
source firewall/bin/activate

# Lancer le pare-feu en arrière-plan
echo "Démarrage du pare-feu..."
python firewall.py &
FW_PID=$!

# lancer tcpdump pour surveiller le trafic réseau
echo "Lancement de tcpdump pour surveiller le trafic réseau..."
sudo tcpdump -i any -n -s 0 -w test.pcap &

# Attendre que tcpdump démarre
sleep 2

# fix du racing condition
sleep 2

# Ajouter la règle qui redirige le trafic vers le pare-feu
echo "Ajout de la règle iptables..."
sudo iptables -I INPUT -j NFQUEUE --queue-num 1

echo "Pare-feu actif (PID: $FW_PID)."
echo "Pour arrêter : 'sudo iptables -D INPUT -j NFQUEUE --queue-num 1' puis tuer le processus $FW_PID"
