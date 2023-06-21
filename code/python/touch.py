"""
touch.py docstring
"""

import argparse
from pathlib import Path
import sys
from typing import Union


def touch(path_file_to_create: Union[str, Path], verbose: bool = True):
    # get the full path of file_path
    file_path = Path(path_file_to_create).resolve()
    # check if the destination does not exist already
    if file_path.exists():
        raise FileExistsError(f"{str(file_path)} already exists")
    # create the empty file
    with open(file_path, "w"):
        pass
    # print the file path on success
    print(file_path) if verbose else ...


if __name__ == "__main__":

    # do not print the full exception traceback
    sys.tracebacklimit = 0

    parser = argparse.ArgumentParser(
        prog="touch",
        description="Creates empty files, UNIX-style",
    )

    # files_paths is a list that defaults empty
    parser.add_argument(
        "files_paths",
        metavar="PATH",
        help="The paths to the empty files to create",
        nargs="*",
        # type=Path
        # type=repr
    )
    parser.add_argument(
        "-v",
        "--verbose",
        metavar="VERBOSE_LEVEL",
        help="",
        type=int,
        default=0,
        choices=[0, 1, 2]
    )
    # verbose level:
    # 0 = print on success and failure
    # 1 = print only on failure
    # 2 = no prints

    args = parser.parse_args()
    # print(args)

    # return the help and exit if files_paths is empty
    if not args.files_paths:
        parser.print_help()
        sys.exit()

    # create a verbose bool for touch
    touch_verbose = not bool(args.verbose)
    for file_path in args.files_paths:
        # print any exception raised by touch
        try:
            touch(file_path, touch_verbose)
        except Exception as e:
            if args.verbose < 2:
                print(e)
