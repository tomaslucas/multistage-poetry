import logging
import pandas as pd

from config_log import add_module_handle

logger = logging.getLogger(__name__)
add_module_handle(logger)


def df_printer(df: pd.DataFrame) -> None:
    logger.info("info called from Print DataFrame from bear.df_printer")
    print(df)
    logger.critical("critical called from Print DataFrame from bear.df_printer")


def main(df):
    df_printer(df)


if __name__ == "__main__":
    df = pd.DataFrame({"day": [1, 2, 3, 4, 5], "month": [6, 7, 8, 9, 10]})
    main(df)
