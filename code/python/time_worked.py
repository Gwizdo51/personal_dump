"""
Script that computes the total amount of time worked for a month, based on an input file.

For example, the following file:

Aout 2023
11: 8h-12h 13h30-18h
12: 8h15-12h 14h15-17h15 17h30-19h30
13: 8h-13h45

will produce the output:

Aout 2023
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


def time_worked_pretty_print(raw_time_worked: str, separator_length: int = 30) -> str:
    """
    This function computes the time worked per day and for a whole month,
    based on an input file, and produces a pretty string to print.

    PARAMETERS
    ----------
    raw_time_worked: str
        The content of the input file.

    RETURNS
    -------
    str
        The pretty string to print.
    """

    result_str_lines = []

    work_hours_lines = raw_time_worked.split("\n")
    work_hours_lines

    month_total_work_duration = 0
    add_newline = False

    # for each line in the input file ...
    for line in work_hours_lines:

        # remove trailing whitespaces
        line = line.strip()

        # skip the line if it is empty
        if len(line) == 0:
            continue

        # only add a newline between each day
        result_str_lines.append("") if add_newline else ...

        if line[0].isdigit():
            # if the line starts with a digit, it is a day line

            # split the line into a list of items
            line_items = line.split()

            # the first item of the line is the day, add it
            day = line_items[0][:-1]
            result_str_lines.append(f"jour: {day}")

            # the other items of the line are the timestamps: "5h-23h15"
            total_work_duration = 0

            # for each timestamp ...
            for work_duration in line_items[1:]:

                # split the timestamp into a list: ["5h", "23h15"]
                hours = work_duration.split("-")

                # split each item at the "h" character: [["5", ""], ["23", "15"]]
                start_time_list = hours[0].split("h")
                end_time_list = hours[1].split("h")

                # replace all "" with "0": [["5", "0"], ["23", "15"]]
                for time in [start_time_list, end_time_list]:
                    if time[1] == "":
                        time[1] = "0"

                # create the same list with integers: [[5, 0], [23, 15]]
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

            add_newline = True

        else:
            # if the line doesn't start with a digit, add it as-is
            result_str_lines.append(line)
            result_str_lines.append("-"*separator_length)

    # add the total amount of time worked this month to the result string
    result_str_lines.append("-"*separator_length)
    result_str_lines.append(f"TOTAL: {month_total_work_duration} heures")

    return "\n".join(result_str_lines)


if __name__ == "__main__":

    # usage:
    # python time_worked.py <input_file_path>
    parser = argparse.ArgumentParser(
        prog="time_worked",
        description="Prints the sum of hours worked based on an input file"
    )
    parser.add_argument(
        "input_file_path",
        metavar="INPUT_FILE_PATH",
        type=Path
    )
    args = parser.parse_args()

    with open(args.input_file_path, "r", encoding="utf_8") as input_file:
        print(time_worked_pretty_print(input_file.read().strip()))
