import logging
from config_log import add_module_handle

logger = logging.getLogger(__name__)
add_module_handle(logger)


def func1():
    logger.debug("debug llamado desde base.func1()")
    logger.critical("critical llamado desde base.func1()")


def main():
    func1()


if __name__ == "__main__":
    main()
