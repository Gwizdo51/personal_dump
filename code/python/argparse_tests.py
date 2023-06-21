import argparse
from pathlib import Path


if __name__ == "__main__":
    pass

    parser = argparse.ArgumentParser(
        description="This great script does wonders!",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    parser.add_argument("src_path", metavar="source_path", help="path to the source", type=Path)
    parser.add_argument("dest_path", metavar="destination_path", help="path to the destination", type=Path)
    parser.add_argument("-l", "--logs", dest="activate_logging", help="whether to add logs", action="store_true")
    parser.add_argument("-m", "--metadata", help="the metadata to do stuff with", choices=["background", "sky", "soil"], default="background")

    args = parser.parse_args()

    print(type(args))
    print(args)
    for item in dir(args):
        print(item)

    # access variables as attributes of args:
    print("source path:", str(args.src_path.resolve()))

    # access variables as keys of a dict:
    args_dict = vars(args)
    print(args_dict.keys())
    print("dest path:", str(args_dict["dest_path"].resolve()))
    print("logs:", args_dict["activate_logging"])
    print("metadata:", args_dict["metadata"])

    # # nargs:
    # #   int => exact number of args
    # #   "?" => 0 or 1 args (needs a default)
    # parser.add_argument("--test", help="nargs test", nargs="?", type=int, default=2)
    # #   "*" any number of args (useful for flags)
    # parser.add_argument('--foo', nargs='*') # defaults to empty list
    # parser.add_argument('--bar', nargs='*') # defaults to None
    # parser.add_argument('baz', nargs='*') # defaults to None

    # args = parser.parse_args()
    # print(args)
    # print(args.foo)
    # print(args.bar)
    # print(args.baz)
    # print(type(args.foo))
