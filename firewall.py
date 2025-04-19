from netfilterqueue import NetfilterQueue
from scapy.all import IP
from logger import setup_logger
from package_handler import is_suspicious

logger = setup_logger()
logger.info("Pare-feu démarré")

def process_packet(packet):
    logger.info("Paquet intercepté")  # DEBUG visible
    pkt = IP(packet.get_payload())

    if is_suspicious(pkt, logger):
        packet.drop()
    else:
        packet.accept()

if __name__ == "__main__":
    nfqueue = NetfilterQueue()
    nfqueue.bind(1, process_packet)

    try:
        logger.info("Écoute de NFQUEUE en cours...")
        nfqueue.run()
    except KeyboardInterrupt:
        logger.info("Arrêt manuel du pare-feu.")
        nfqueue.unbind()
