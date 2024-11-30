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

# <must not be positional> / <can be positional or named> * <must be named>

def func_test(arg_1, /, arg_2, *, arg_3):
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


#################
### metaclass ###
#################

# dynamic class creation
def choose_class(name):
    if name == 'foo':
        class Foo:
            pass
        return Foo # return the class, not an instance
    elif name == "bar":
        class Bar:
            pass
        return Bar
    else:
        print("not found")

# type(name, bases, attrs) class creation
class ParentClass:
    parent_attribute = False
def my_class_method(self: MyClass) -> Any:
    print(self.key)
name = "MyClass"
bases = (ParentClass,)
attrs = {
    "key": "value",
    "my_class_method": my_class_method
}
MyClass = type(name, bases, attrs)

# metaclasses are class factories => can be any callable that returns a class
def my_metaclass(future_class_name, future_class_parents, future_class_attrs: dict):
    # pick up any attribute that doesn't start with '__' and uppercase it
    uppercase_attrs = {attr if attr.startswith("__") else attr.upper(): v for attr, v in future_class_attrs.items()}
    # let `type` do the class creation
    my_metaclass_return = type(future_class_name, future_class_parents, uppercase_attrs)
    return my_metaclass_return
# __metaclass__ = my_metaclass
class MyClassInstance(metaclass=my_metaclass):
    # __metaclass__ = my_metaclass
    bar = 'bip'


##################
### decorators ###
##################


#############
### flags ###
#############

def flags_test():
    flag_0 = 1 << 0
    flag_1 = 1 << 1
    flag_2 = 1 << 2
    flag_3 = 1 << 3
    flag_4 = 1 << 4
    flag_5 = 1 << 5
    flags = [flag_0, flag_1, flag_2, flag_3, flag_4, flag_5]
    # for flag in flags:
    #     print(flag)
    flag_test = 0
    # turn flags on
    flag_test |= flag_3 | flag_1 | flag_5
    print(flag_test)
    print(bin(flag_test))
    # check if bit is set
    print(bool(flag_test & flag_0))
    print(flag_test & flag_0 > 0)
    print(bool(flag_test & flag_1))
    print(flag_test & flag_1 > 0)
    print(bool(flag_test & flag_2))
    print(bool(flag_test & flag_3))
    print(~flag_test)
    print(bin(~flag_test))
    # turn flags off
    flag_test &= ~flag_3
    flag_test &= ~flag_3
    flag_test &= ~flag_3
    print(flag_test)
    print(bin(flag_test))
    print(bool(flag_test & flag_0))
    print(bool(flag_test & flag_1))
    print(bool(flag_test & flag_2))
    print(bool(flag_test & flag_3))


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
    # title_printer("flags")
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

    # # __dict__ behavior
    # class Test:
    #     pass
    # print("test = Test()")
    # test = Test()
    # print(test)
    # print()
    # print("Test.__mro__ (Method Resolution Order)")
    # print(Test.__mro__)
    # print(type(Test.__mro__))
    # print()
    # print("Test.__dict__")
    # print(Test.__dict__)
    # print(type(Test.__dict__))
    # print()
    # print('test.a = "lol"')
    # test.a = "lol"
    # print(test.a)
    # print()
    # print('object.__setattr__(test, "b", "kekw")')
    # object.__setattr__(test, "b", "kekw")
    # print(test.b)
    # print()
    # print("test.__dict__")
    # print(test.__dict__)
    # print(type(test.__dict__))
    # print()
    # print("vars(test)")
    # print(vars(test))
    # print(type(vars(test)))
    # print()
    # print("setting to __dict__ and vars")
    # test.__dict__["c"] = "thing"
    # vars(test)["d"] = [1,2,3]
    # print(test.c)
    # print(test.d)
    # print()
    # print("setting to a pointer of __dict__ and vars")
    # dict_pointer = test.__dict__
    # dict_pointer["e"] = "maybe"
    # print(test.e)
    # vars_pointer = vars(test)
    # vars_pointer["f"] = "it works"
    # print(test.f)

    # # metaclass
    # for name in ["foo", "bar"]:
    #     print(name, "class:")
    #     class_returned = choose_class(name)
    #     print(class_returned)
    # obj = MyClass()
    # print(obj)
    # print(MyClass.key)
    # print(MyClass.my_class_method)
    # obj.my_class_method()
    # # Parent classes
    # print(obj.parent_attribute)
    # # all objects metaclass
    # print(obj.__class__.__class__)
    # print(object.__class__)
    # # type class is type
    # print(object.__class__.__class__)
    # obj = MyClassInstance()
    # print(obj)
    # # print(obj.bar)
    # print(obj.BAR)
    # print(MyClassInstance)
    # print(MyClassInstance.__mro__)
    # print(MyClassInstance.__class__)

    # flags
    flags_test()

    ############
    ### DUMP ###
    ############

    # print(type(locals())
    # locals_1 = locals().copy()
    # for key in locals_1:
    #     if not ("__" in key):
    #         print(key)
