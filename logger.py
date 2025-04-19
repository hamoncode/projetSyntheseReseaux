import os
import logging

def setup_logger(log_file=None):
    if log_file is None:
        log_file = os.path.join(os.getcwd(), "firewall.log")
    
    logging.basicConfig(
        filename=log_file,
        level=logging.INFO,
        format='%(asctime)s %(levelname)s: %(message)s'
    )
    return logging.getLogger("firewall")
