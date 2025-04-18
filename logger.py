import logging

# set up un log file pour entrer les informations des paquets
def setup_logger(log_file="/var/log/firewall.log"):
    logging.basicConfig(
        filename=log_file,
        level=logging.INFO,
        format='%(asctime)s %(levelname)s: %(message)s'
    )
    return logging.getLogger("firewall")
