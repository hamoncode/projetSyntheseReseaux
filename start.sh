#!/bin/bash

# verifier que le script est exécuté avec les droits root
if [ "$EUID" -ne 0 ]; then
    echo "Veuillez exécuter ce script avec sudo."
    exit 1
fi

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
tcpdump -nn -r test.pcap

# Attendre que tcpdump démarre
sleep 2

# capturer le trafic pour tester
tshark -r test.pcap

# fix du racing condition
sleep 2

# Ajouter la règle qui redirige le trafic vers le pare-feu
echo "Ajout de la règle iptables..."
iptables -I INPUT -j NFQUEUE --queue-num 1

echo "Pare-feu actif (PID: $FW_PID)."
echo "Pour arrêter : 'sudo iptables -D INPUT -j NFQUEUE --queue-num 1' puis tuer le processus $FW_PID"
