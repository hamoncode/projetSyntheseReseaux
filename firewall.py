from netfilterqueue import NetfilterQueue
from scapy.all import IP
from logger import setup_logger
from package_handler import is_suspicious

logger = setup_logger()

def process_packet(packet):
    pkt = IP(packet.get_payload())
    print("Packet intercepté")
    if is_suspicious(pkt, logger):
        packet.drop()
    else:
        packet.accept()

if __name__ == "__main__":
    nfqueue = NetfilterQueue()
    nfqueue.bind(1, process_packet)

    print("Firewall Python en cours d'exécution...")
    try:
        nfqueue.run()
    except KeyboardInterrupt:
        print("Arrêt du pare-feu.")
        nfqueue.unbind()
