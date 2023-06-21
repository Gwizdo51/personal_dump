import argparse
from pathlib import Path
import sys


if __name__ == "__main__":

    # don't print the full traceback
    sys.tracebacklimit = 0

    parser = argparse.ArgumentParser(
        description="Creates an empty file with the specified path",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    parser.add_argument("file_path", help="The path to the file to create", type=Path)

    args_dict = vars(parser.parse_args())
    file_path = args_dict["file_path"].resolve()

    # check if the destination doesn't already exist
    if file_path.exists():
        raise FileExistsError(f"the path {str(file_path)} already exists")

    # create the empty file
    with open(file_path, mode="w") as f:
        f.write("")

    # print the file path to confirm success
    print(file_path)
