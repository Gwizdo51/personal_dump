"""
Script that computes the total amount of time worked for a month,
based on an input file with a specific format.

For example, the following file:

Août 2023
11: 8h-12h 13h30-18h
12: 8h15-12h 14h15-17h15 17h30-19h30
13: 8h-13h45

will produce the output:

Août 2023
------------------------------
jour: 11
heures travaillées: 8.5

jour: 12
heures travaillées: 8.75

jour: 13
heures travaillées: 5.75
------------------------------
TOTAL: 23.0 heures
"""

import argparse
from pathlib import Path
import sys
import re


class FileTypeError(Exception):
    "Raised when the input file is not a .txt file."


class FormatError(Exception):
    "Raised when the contents of the input file do not comply with the expected format."


def time_worked_pretty_print(raw_time_worked_data: str, separator_length: int = 30) -> str:
    """
    This function computes the time worked per day and for a whole month,
    based on an input file, and produces a pretty string to print.

    PARAMETERS
    ----------
    raw_time_worked: str
        The contents of the input file.
    separator_length: int = 30
        The amount of dashes ("-") that the separator line contains.

    RETURNS
    -------
    str
        The pretty string to print.

    RAISES
    ------
    RuntimeError
        Raised if the contents of the input file do not comply with the expected format.
    """

    # check input data format
    input_file_regex_format = re.compile(r"^.+\n(\d\d: +(\d{1,2}h(\d\d)?-\d{1,2}h(\d\d)? *)+\n?)+$")
    if not input_file_regex_format.match(raw_time_worked_data):
        raise FormatError("The contents of the input file do not comply with the expected format")

    result_str_lines = []

    # make a list of lines
    work_hours_lines = raw_time_worked_data.split("\n")
    work_hours_lines

    month_total_work_duration = 0

    # for each line in the input file ...
    for line_number, line in enumerate(work_hours_lines):

        # remove trailing whitespaces
        line = line.strip()

        if line_number == 0:
            # the first line is the month line, add it to the result string: "Août 2023"
            result_str_lines.append(line)
            result_str_lines.append("-"*separator_length)

        else:
            # every line after the first one is a day line: "08: 5h-23h15"

            # only add a newline between each day
            if line_number >= 2:
                result_str_lines.append("")

            # split the line into a list of items
            line_items = line.split()

            # the first item of the line is the day, add it to the result string: "08"
            day = line_items[0][:-1]
            result_str_lines.append(f"jour: {day}")

            # the other items of the line are the timestamps
            total_work_duration = 0

            # for each timestamp: "5h-23h15"
            for work_duration in line_items[1:]:

                # split the timestamp into a list: ["5h", "23h15"]
                hours = work_duration.split("-")

                # split each item at the "h" character: ["5", ""], ["23", "15"]
                start_time_list = hours[0].split("h")
                end_time_list = hours[1].split("h")

                # replace all "" with "0": ["5", "0"], ["23", "15"]
                if start_time_list[1] == "":
                    start_time_list[1] = "0"
                if end_time_list[1] == "":
                    end_time_list[1] = "0"

                # create the same list with integers: [5, 0], [23, 15]
                start_time_int_list = [int(item) for item in start_time_list]
                end_time_int_list = [int(item) for item in end_time_list]

                # transform the minutes into fractions of hours and add them to the hours: 5, 23.25
                start_time_decimal = start_time_int_list[0] + start_time_int_list[1] / 60
                end_time_decimal = end_time_int_list[0] + end_time_int_list[1] / 60

                # the difference is the total amout of time worked for this timestamp: 23.25 - 5 = 18.25 hours worked
                # add it to the daily total
                total_work_duration += end_time_decimal - start_time_decimal

            # add the total time worked for that day to the result string
            result_str_lines.append(f"heures travaillées: {total_work_duration}")

            # add it to the monthly total
            month_total_work_duration += total_work_duration

    # add the total amount of time worked this month to the result string
    result_str_lines.append("-"*separator_length)
    result_str_lines.append(f"TOTAL: {month_total_work_duration} heures")

    return "\n".join(result_str_lines)


if __name__ == "__main__":

    # usage:
    # python time_worked.py <input_file_path>
    parser = argparse.ArgumentParser(
        prog="python time_worked.py",
        description="Prints the sum of hours worked based on an input file"
    )
    parser.add_argument(
        "input_file_path",
        metavar="<input_file_path>",
        type=str
    )
    args = parser.parse_args()

    # do not print the full exceptions tracebacks for clarity
    sys.tracebacklimit = 0

    input_file_path = Path(args.input_file_path)

    # check that input_file_path leads to a .txt file
    if not input_file_path.exists():
        raise FileNotFoundError(f"No file found: '{str(input_file_path)}'")
    if not input_file_path.is_file():
        raise IsADirectoryError(f"input_file_path leads to a directory: '{str(input_file_path)}'")
    if input_file_path.suffix.lower() != ".txt":
        raise FileTypeError(f"'{str(input_file_path)}' is not a .txt file")

    # print the output of time_worked_pretty_string
    with open(file=args.input_file_path, mode="r", encoding="utf_8") as input_file:
        print(time_worked_pretty_print(input_file.read().strip()))
