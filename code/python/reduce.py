from functools import reduce

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

if __name__ == "__main__":
    print(_len(["a", "b", "c"]))
    print(_sum([3,1,2]))
    print(_any([False, False]))
    print(_any([False, True]))
    print(_all([True, True]))
    print(_all([False, True]))
    print(_max([1,5,-2]))
    print(_min([1,5,-2]))
