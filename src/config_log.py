import logging

# Creatte a custom logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


def add_module_handle(logger, level=logging.WARNING):
    # Create handlers
    c_handler = logging.StreamHandler()
    f_handler = logging.FileHandler(
        f"/tmp/module-{logger.name.replace('.','-')}.log", mode="w"
    )
    f_pp_handler = logging.FileHandler(f"/tmp/proy1.log")
    c_handler.setLevel(level)
    f_handler.setLevel(level)

    # Create formatters and add it to handlers
    c_format = logging.Formatter("%(name)s - %(levelname)s - %(message)s")
    f_format = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
    f_pp_format = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    )
    c_handler.setFormatter(c_format)
    f_handler.setFormatter(f_format)
    f_pp_handler.setFormatter(f_pp_format)

    logger.addHandler(c_handler)
    logger.addHandler(f_handler)
    logger.addHandler(f_pp_handler)
