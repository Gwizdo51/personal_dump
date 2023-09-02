"""
touch.py docstring
"""

import argparse
from pathlib import Path
import sys
from typing import Union


def touch(path_file_to_touch: Union[str, Path], verbose: bool = True) -> bool:
    """
    Touch a file. Update the file "last modified" date if it exists,
    create it if it doesn't exist.

    PARAMETERS
    ----------
    path_file_to_touch: str | Path
        The path to the file to create.
    verbose: bool = True
        Whether to print on success.

    RETURNS
    -------
    bool
        Whether the file existed before being touched.
    """
    # get the absolute path of path_file_to_touch
    file_path = Path(path_file_to_touch).resolve()
    file_existed = file_path.exists()
    # touch the file
    with open(file_path, "ab"):
        pass
    # print the file absolute path on success
    print(file_path) if verbose else ...
    return file_existed


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        prog="touch",
        description="Touches files, UNIX-style"
    )

    # args.files_paths is a list that defaults empty
    parser.add_argument(
        "files_paths",
        metavar="<files_paths>",
        help="The paths to the empty files to create",
        nargs="*"
    )
    parser.add_argument(
        "-v",
        "--verbose",
        metavar="<verbose_level>",
        help="0: all prints | 1: only errors | 2: no prints (default: 0)",
        type=int,
        choices=[0, 1, 2],
        default=0
    )

    args = parser.parse_args()

    # do not print the full exceptions tracebacks for clarity
    sys.tracebacklimit = 0

    # return the help and exit if files_paths is empty
    if not args.files_paths:
        parser.print_help()
        sys.exit()

    # create a verbose bool for touch
    touch_verbose = not bool(args.verbose)
    for file_path in args.files_paths:
        # call touch, print any exception raised
        try:
            touch(file_path, touch_verbose)
        except Exception as e:
            if args.verbose < 2:
                print(e)
