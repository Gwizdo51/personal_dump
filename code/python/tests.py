from __future__ import annotations
from functools import reduce
from typing import Any


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


##############################
### named and unnamed args ###
##############################

# <must not be named> / <can be name or not> * <must be named>

def func_test(unnamed_arg, /, unnamed_arg_2, *, named_arg = 0):
    pass


#################
### generator ###
#################


###############
### __new__ ###
###############

class A:

    def __new__(cls, *args, **kwargs) -> A:
        print("A __new__ call")
        print("cls:", cls.__name__)
        print("object __new__ call")
        obj = object.__new__(cls, *args, **kwargs)
        # obj.foo = "bar"
        return obj

    def __init__(self, *args, **kwargs):
        print("A __init__ call")
        print("object __init__ call")
        object.__init__(self, *args, **kwargs)

    def __setattr__(self, *args, **kwargs) -> None:
        print("A __setattr__ call")
        print("object __setattr__ call")
        object.__setattr__(self, *args, **kwargs)

class B(A):

    def __new__(cls, *args, **kwargs) -> B:
        print("B __new__ call")
        print("cls:", cls.__name__)
        obj = A.__new__(cls, *args, **kwargs)
        # obj.foo = "bar"
        return obj

    def __init__(self, *args, **kwargs):
        print("B __init__ call")
        A.__init__(self, *args, **kwargs)

    def __setattr__(self, *args, **kwargs) -> None:
        print("B __setattr__ call")
        A.__setattr__(self, *args, **kwargs)


###########################
### RegEx UUID detector ###
###########################


if __name__ == "__main__":

    # print(_len(["a", "b", "c"]))
    # print(_sum([3,1,2]))
    # print(_any([False, False]))
    # print(_any([False, True]))
    # print(_all([True, True]))
    # print(_all([False, True]))
    # print(_max([1,5,-2]))
    # print(_min([1,5,-2]))

    title_printer("RegEx UUID detector")
    # title_printer("generator", fill_char="+")

    # func_test(unnamed_arg=1, unnamed_arg_2=2, named_arg=3)
    # func_test(1, 2, 3)

    # A()
    # B()
    # type({}.values())()
    # print(object.__new__(A))
    # print(A.__new__(A))
    # print(B.__new__(B))
    # weird stuff:
    # test = B.__new__(A)
    # print(type(test))
    # print(A.__new__(object))
