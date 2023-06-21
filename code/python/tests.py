from __future__ import annotations
from functools import reduce
from typing import Any, Type, Union


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

list_test = [1,2,3]
test_generator = (item for item in list(list_test))

def infinite_sequence():
    num = 0
    while True:
        yield num
        num += 1
        if num == 100000:
            break


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


############################
### is instance or class ###
############################

def is_type(obj_or_type: Union[Any, Type[object]]) -> bool:
    return type(obj_or_type) is type

def is_instance(obj_or_type: Union[Any, Type[object]]) -> bool:
    return not is_type(obj_or_type)


if __name__ == "__main__":
    pass

    # # functools.reduce
    # print(_len(["a", "b", "c"]))
    # print(_sum([3,1,2]))
    # print(_any([False, False]))
    # print(_any([False, True]))
    # print(_all([True, True]))
    # print(_all([False, True]))
    # print(_max([1,5,-2]))
    # print(_min([1,5,-2]))

    # # title_printer
    # title_printer("is instance or class")
    # title_printer("generator", fill_char="+")

    # # named and unnamed args
    # func_test(unnamed_arg=1, unnamed_arg_2=2, named_arg=3)
    # func_test(1, 2, 3)

    # # generator
    # print(type(test_generator))
    # print(next(test_generator))
    # print(next(test_generator))
    # print(next(test_generator))
    # try:
    #     next(test_generator)
    # except StopIteration:
    #     print("no more items")
    # print(test_generator.__iter__.__doc__)
    # print()
    # for item in dir(test_generator):
    #     print(item)
    # print()
    # print(type(test_generator).__mro__)
    # gen = infinite_sequence()
    # while True:
    #     print(next(gen), end=" ")

    # # __new__
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

    # RegEx UUID detector

    # # is instance or class
    # print(is_instance([]))
    # print(is_type([]))
    # print(is_instance(list))
    # print(is_type(list))
    # print(is_instance(type))

    # print(type(locals())
    # locals_1 = locals().copy()
    # for key in locals_1:
    #     if not ("__" in key):
    #         print(key)

    # __dict__ behavior
    class Test:
        pass
    print("test = Test()")
    test = Test()
    print(test)
    print()
    print("Test.__mro__ (Method Resolution Order)")
    print(Test.__mro__)
    print(type(Test.__mro__))
    print()
    print("Test.__dict__")
    print(Test.__dict__)
    print(type(Test.__dict__))
    print()
    print('test.a = "lol"')
    test.a = "lol"
    print(test.a)
    print()
    print('object.__setattr__(test, "b", "kekw")')
    object.__setattr__(test, "b", "kekw")
    print(test.b)
    print()
    print("test.__dict__")
    print(test.__dict__)
    print(type(test.__dict__))
    print()
    print("vars(test)")
    print(vars(test))
    print(type(vars(test)))
    print()
    print("setting to __dict__ and vars")
    test.__dict__["c"] = "thing"
    vars(test)["d"] = [1,2,3]
    print(test.c)
    print(test.d)
    print()
    print("setting to a pointer of __dict__ and vars")
    dict_pointer = test.__dict__
    dict_pointer["e"] = "maybe"
    print(test.e)
    vars_pointer = vars(test)
    vars_pointer["f"] = "it works"
    print(test.f)
