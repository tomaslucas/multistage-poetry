import logging
from config_log import add_module_handle

logger = logging.getLogger(__name__)
add_module_handle(logger)


def func2():
    logger.debug("debug creado desde utils.func2()")
    logger.critical("critical creado desde utils.func2()")
