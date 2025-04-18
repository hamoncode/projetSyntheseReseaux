import json
from scapy.all import IP, TCP, UDP
from logger import setup_logger

def is_suspicious(packet):
    ip_layer = packet.getlayer(IP)

    if packet.haslayer(TCP) and packet[TCP].dport == 12345:
        logger.info(f"Blocked TCP port 12345 from {ip_layer.src}")
        return True

    return False

