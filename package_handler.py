import json
from scapy.all import IP, TCP, UDP
from logger import setup_logger

with open("config.json") as f:
    config = json.load(f)

logger = setup_logger()

def is_suspicious(packet):
    ip_layer = packet.getlayer(IP)

    if ip_layer.src in config["blocked_ips"]:
        logger.info(f"Blocked IP: {ip_layer.src}")
        return True

    if packet.haslayer(TCP) and packet[TCP].dport in config["blocked_ports"]:
        logger.info(f"Blocked TCP port {packet[TCP].dport} from {ip_layer.src}")
        return True

    if packet.haslayer(UDP) and packet[UDP].dport in config["blocked_ports"]:
        logger.info(f"Blocked UDP port {packet[UDP].dport} from {ip_layer.src}")
        return True

    return False
