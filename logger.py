import logging

def setup_logger():
    logger = logging.getLogger("firewall")
    logger.setLevel(logging.INFO)

    # Ne pas créer plusieurs handlers si déjà fait
    if not logger.handlers:
        handler = logging.FileHandler("/home/firewalltester/projetSyntheseReseaux/firewall.log")
        formatter = logging.Formatter('%(asctime)s %(levelname)s: %(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)

    return logger

