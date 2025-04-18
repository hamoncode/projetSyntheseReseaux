import json
from scapy.all import Raw

with open("config.json", "r") as f:
    config = json.load(f)

blocked_ips = config.get("blocked_ips", [])
blocked_ports = config.get("blocked_ports", [])
suspicious_keywords = config.get("suspicious_keywords", [])

def is_suspicious(packet, logger):
    ip_layer = packet.getlayer("IP")

    logger.info("Analyse du paquet")

    if ip_layer and (ip_layer.src in blocked_ips or ip_layer.dst in blocked_ips):
        logger.info(f"IP bloquée : {ip_layer.src} -> {ip_layer.dst}")
        return True

    if packet.haslayer("TCP"):
        sport = packet["TCP"].sport
        dport = packet["TCP"].dport
        if sport in blocked_ports or dport in blocked_ports:
            logger.info(f"Port TCP bloqué : sport={sport}, dport={dport}")
            return True

    if packet.haslayer("UDP"):
        sport = packet["UDP"].sport
        dport = packet["UDP"].dport
        if sport in blocked_ports or dport in blocked_ports:
            logger.info(f"Port UDP bloqué : sport={sport}, dport={dport}")
            return True

    if packet.haslayer(Raw):
        payload = packet[Raw].load.decode(errors="ignore").lower()
        for keyword in suspicious_keywords:
            if keyword.lower() in payload:
                logger.info(f"Mot-clé suspect détecté : '{keyword}'")
                return True

    logger.info("Paquet accepté")
    return False
