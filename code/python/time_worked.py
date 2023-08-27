"""
time_worked.py docstring
"""

import argparse
from pathlib import Path


# def time_worked_pretty_print(raw_time_worked: str, rectifications: dict[int, float] = {}) -> str:
def time_worked_pretty_print(raw_time_worked: str) -> str:

    result_str_lines = []

    work_hours_lines = raw_time_worked.split("\n")
    work_hours_lines

    # rectifications = {
    #     23: 0.25
    # }

    month_total_work_duration = 0
    print_newline = False

    for line in work_hours_lines:

        line = line.strip()

        # only print a newline between each day
        # print() if print_newline else ...
        result_str_lines.append("") if print_newline else ...

        if len(line) == 0:
            # skip the line if it is empty
            continue

        elif line[0].isdigit():
            # if the line starts with a digit, it is a day line

            # use the space character to split the line into a list
            line_items = line.split()

            # the first item of the line is the day, print it
            day_str = line_items[0][:-1]
            day_int = int(day_str)
            # print("jour:", day_str)
            result_str_lines.append(f"jour: {day_str}")

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
                start_time_decimal = start_time_int_list[0] + start_time_int_list[1] * (100/60) / 100
                end_time_decimal = end_time_int_list[0] + end_time_int_list[1] * (100/60) / 100

                # the difference is the total amout of time worked for this timestamp: 23.25 - 5 = 18.25 hours worked
                # add it to the total
                total_work_duration += end_time_decimal - start_time_decimal

            # apply daywise rectifications
            # total_work_duration += rectifications.get(day_int, 0)

            # print the total time worked for that day
            # print("heures travaillées:", total_work_duration)
            result_str_lines.append(f"heures travaillées: {total_work_duration}")

            # add it to the total
            month_total_work_duration += total_work_duration

            print_newline = True

        else:
            # if the line doesn't start with a digit, print it as-is
            # print(line)
            # print("-"*30)
            result_str_lines.append(line)
            result_str_lines.append("-"*30)

    # print the total amount of time worked this month
    # print("-"*30)
    # print("TOTAL:", month_total_work_duration, "heures")
    result_str_lines.append("-"*30)
    result_str_lines.append(f"TOTAL: {month_total_work_duration} heures")

    return "\n".join(result_str_lines)


if __name__ == "__main__":

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

    with open(args.input_file_path) as f:
        print(time_worked_pretty_print(f.read()))
