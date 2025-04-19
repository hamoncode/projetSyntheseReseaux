import json
from scapy.all import Raw

with open("config.json", "r") as f:
    config = json.load(f)

blocked_ips = config.get("blocked_ips", [])
blocked_ports = config.get("blocked_ports", [])
suspicious_keywords = config.get("suspicious_keywords", [])

def is_suspicious(packet):
    ip_layer = packet.getlayer("IP")

    # Check IPs
    if ip_layer and (ip_layer.src in blocked_ips or ip_layer.dst in blocked_ips):
        return True

    # Check ports
    if packet.haslayer("TCP") and (
        packet["TCP"].sport in blocked_ports or packet["TCP"].dport in blocked_ports
    ):
        return True
    if packet.haslayer("UDP") and (
        packet["UDP"].sport in blocked_ports or packet["UDP"].dport in blocked_ports
    ):
        return True

    # Check suspicious content
    if packet.haslayer(Raw):
        payload = packet[Raw].load.decode(errors="ignore").lower()
        for keyword in suspicious_keywords:
            if keyword.lower() in payload:
                return True

    return False
