import sys
from pathlib import Path
import logging
import os
from datetime import datetime

ROOT_DIR_PATH = str(Path(__file__).resolve().parent)
if ROOT_DIR_PATH not in sys.path:
    sys.path.insert(0, ROOT_DIR_PATH)


class LoggerFactory:
    """
    This class handles the creation of loggers for each submodule that requires logging.
    The logs will be printed in the console as well as recorded in log files that will
    be stored in a "logs" directory on the same level as this file.
    Each new run will generate a new log file named using the current date and time:
    YYYYMMDD_hhmmss.log

    How to use: import this class and add:
        logger = LoggerFactory.get_logger(__name__)
    at the top of your file.
    """


    # Class attribute that stores whether a log file
    # has been created for this run. When a log file is created,
    # it will store the path to the log file.
    _log_file_path = None

    # The path to the "logs" directory (created if it doesn't exist)
    _logs_dir_path = Path(ROOT_DIR_PATH) / "logs"


    @staticmethod
    def _gen_log_file_name() -> str:
        """
        Hidden class method used by get_logger to generate the new log file name.
        Shouldn't be used.

        PARAMS
            None

        RETURNS
            str
                The new log file name.
        """
        # get the current date and time in the format "YYYYMMDD_hhmmss"
        datetime_str = datetime.now().strftime("%Y%m%d_%H%M%S")
        # return the new log file name by adding ".log"
        return datetime_str + ".log"


    @classmethod
    def get_logger(cls, name: str) -> logging.Logger:
        """
        Class method used to create a new logger.

        PARAMS
            name: str
                The name of the logger.

        RETURNS
            logging.Logger
                The logger object.
        """

        # create a new logger
        logger = logging.getLogger(name)
        logger.setLevel(logging.DEBUG)

        # add a console handler to the logger
        console_formatter = logging.Formatter('%(filename)s - %(funcName)s - %(levelname)s - %(message)s')
        console_handler = logging.StreamHandler()
        console_handler.setLevel(logging.INFO)
        console_handler.setFormatter(console_formatter)
        logger.addHandler(console_handler)

        # create a "logs" directory if it doesn't exist yet
        if not os.path.isdir(cls._logs_dir_path):
            os.mkdir(cls._logs_dir_path)

        # add a file handler to the logger
        # if a log file hasn't been created for this run yet, create one
        if not cls._log_file_path:
            cls._log_file_path = str(cls._logs_dir_path / cls._gen_log_file_name())
        file_handler = logging.FileHandler(cls._log_file_path)
        file_formatter = logging.Formatter('%(asctime)s - module: %(filename)s - function: %(funcName)s - %(levelname)s - %(message)s')
        file_handler.setLevel(logging.DEBUG)
        file_handler.setFormatter(file_formatter)
        logger.addHandler(file_handler)

        return logger


if __name__ == "__main__":
    # logger = LoggerFactory.get_logger("test")
    # logger.info("this is a test info")
    # logger.debug("this is a test debug")
    pass
