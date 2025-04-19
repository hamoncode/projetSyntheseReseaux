import os
import logging

def setup_logger(log_file=None):
    # Chemin absolu garanti pour le log
    if log_file is None:
        log_file = "/home/firewalltester/projetSyntheseReseaux/firewall.log"

    logging.basicConfig(
        filename=log_file,
        level=logging.INFO,
        format='%(asctime)s %(levelname)s: %(message)s'
    )

    return logging.getLogger("firewall")
