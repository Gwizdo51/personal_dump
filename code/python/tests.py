from functools import reduce


########################
### functools.reduce ###
########################

# sum(), any(), all(), max(), min(), and len()

_len = lambda it: reduce(
    lambda value, element: value + 1,
    it,
    0
)

_sum = lambda it: reduce(
    lambda value, element: value + element,
    it
)

_any = lambda it: reduce(
    lambda value, element: bool(value) or bool(element),
    it,
    False
)

_all = lambda it: reduce(
    lambda value, element: bool(value) and bool(element),
    it,
    True
)

_max = lambda it: reduce(
    lambda value, element: element if element > value else value,
    it
)

_min = lambda it: reduce(
    lambda value, element: element if element < value else value,
    it
)


#####################
### title printer ###
#####################

def title_printer(title: str, fill_char: str = "#", print_: bool = True) -> str:
    """
    ###########################
    ### super awesome title ###
    ###########################
    """
    # assert len(fill_char) == 1, "lol"
    if len(fill_char) != 1:
        raise ValueError("fill_char must be a string of exactly one character")
    # create title string
    title_lines = []
    title_lines.append(fill_char*(8 + len(title)))
    title_lines.append(fill_char*3 + " " + title.strip() + " " + fill_char*3)
    title_lines.append(fill_char*(8 + len(title)))
    title_string = "\n".join(title_lines)
    # print it and return it
    if print_:
        print(title_string)
    return title_string


if __name__ == "__main__":

    print(_len(["a", "b", "c"]))
    print(_sum([3,1,2]))
    print(_any([False, False]))
    print(_any([False, True]))
    print(_all([True, True]))
    print(_all([False, True]))
    print(_max([1,5,-2]))
    print(_min([1,5,-2]))

    title_printer("super awesome title")
    title_printer("other super awesome title", fill_char="+")
