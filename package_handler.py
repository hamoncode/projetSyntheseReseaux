import json
from scapy.all import IP, TCP, UDP
from logger import setup_logger

# Set up the logger
logger = setup_logger()

# Load configuration from config.json
with open("config.json", "r") as config_file:
    config = json.load(config_file)

blocked_ports = config.get("blocked_ports", [])
blocked_ips = config.get("blocked_ips", [])

def is_suspicious(packet):
    ip_layer = packet.getlayer(IP)

    # Check if the packet's source IP is in the blocked IPs list
    if ip_layer.src in blocked_ips:
        logger.info(f"Blocked packet from IP {ip_layer.src}")
        return True

    # Check if the packet's destination port is in the blocked ports list
    if packet.haslayer(TCP) and packet[TCP].dport in blocked_ports:
        logger.info(f"Blocked TCP port {packet[TCP].dport} from {ip_layer.src}")
        return True

    if packet.haslayer(UDP) and packet[UDP].dport in blocked_ports:
        logger.info(f"Blocked UDP port {packet[UDP].dport} from {ip_layer.src}")
        return True

    return False