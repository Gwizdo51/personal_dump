from __future__ import annotations
import re
import json
from typing import Optional, Any, Union
from types import MappingProxyType
from collections.abc import Mapping


class KeyTypeError(Exception):
    """
    A custom exception for the DotDict class. Raised when a trying to use
    DotDict with a key that is not a string.
    """


class AttributeNameError(Exception):
    """
    A custom exception for the DotDict Class. Raised when trying to use
    DotDict with a key that cannot with used as an attribute name.
    """


# def test_1(param_0: bool, param_1: int = 2) -> Optional[Union[float, int]]:
#     """
#     _summary_

#     PARAMS
#     ------
#         param_0: bool
#             _description_
#         param_1: int = 2
#             _description_

#     RETURNS
#     -------
#         float
#             _description_

#     RAISES
#     ------
#         KeyTypeError
#             slkdjfq
#     """


def is_mapping(obj: Any) -> bool:
    """
    Returns whether the object pass is a mapping of some kind.
    """
    return isinstance(obj, Mapping)


def is_iterable_not_string_like(obj: Any) -> bool:
    """
    Returns whether the object is an iterable, but not string-like
    (this function will return False if the object type is "str", "bytes"
    or "bytearray").
    """
    # check if obj is iterable
    try:
        iter(obj)
        obj_is_iterable = True
    except:
        obj_is_iterable = False
    # check if obj is a string-like object
    # (str, bytes and bytearray objects are iterable)
    obj_is_str_like = repr(obj)[0] in ["'", "b"]
    return obj_is_iterable and not obj_is_str_like


# best attempt at defining a Regular Expression for an attribute name
attribute_name_pattern_string = "^[a-zA-Z]\w*$"
attribute_name_pattern = re.compile(attribute_name_pattern_string)
# dict class method names
dict_method_names = [meth_name for meth_name in dir(dict) if not ("_" in meth_name)]


def check_key(key):
    # check if the key is a string
    if not (type(key) is str):
        raise KeyTypeError(f"The key '{key}' is not a string")
    # check if the key is accessible as a visible attribute
    if not attribute_name_pattern.match(key):
        raise AttributeNameError(f"The key '{key}' is not valid as a DotDict attribute name")
    # check whether the key would erase a dict method
    if key in dict_method_names:
        raise AttributeNameError(f"The key '{key}' would erase a dict method")


def check_keys(dict_to_check: dict):
    """
    Recursively checks if the keys of dict_to_check and its nested dictionaries
    are accessible as attribute names, and will not replace any methods from the
    "dict" class.
    """
    for key in dict_to_check.keys():
        check_key(key)
        # if the value is a dict, check for its keys as well
        value = dict_to_check[key]
        if type(value) is dict:
            check_keys(value)


def clean_types(dict_to_check: dict) -> dict:
    """
    Recursively converts the types of all the values of dict_to_check and its
    nested mappings to "dict" when they are mappings of any kind.
    """
    # placeholder for the clean dict
    cleaned_dict = {}
    for key in dict_to_check.keys():
        value = dict_to_check[key]
        # convert the value to a dict if if is a mapping of any kind
        if is_mapping(value):
            value = dict(value)
        # clean the types of the value's nested mappings if it is a dict
        if type(value) is dict:
            value = clean_types(value)
        # add the clean value to the clean dict
        cleaned_dict[key] = value
    # return the clean dict
    return cleaned_dict


def _pretty_string_factory_object_processor(item_to_process: Any) -> Any:
    """

    """
    if is_mapping(item_to_process):
        # if the item is a mapping, convert it to a dict
        item_to_process = dict(item_to_process)
        if not item_to_process:
            # if the dict is empty, return it as is
            processed_item = item_to_process
        else:
            # process item_to_process content in place
            for key, value in item_to_process.items():
                item_to_process[key] = _pretty_string_factory_object_processor(value)
            processed_item = item_to_process
    elif is_iterable_not_string_like(item_to_process):
        # if the item is an "openable" iterable...
        if not item_to_process:
            # special case if the iterable is empty
            processed_item = item_to_process
        else:
            # try to figure out what type of iterable item_to_process is
            if str(item_to_process)[0] == "(":
                # tuple-like
                type_to_use = tuple
            elif str(item_to_process)[0] == "{":
                # set-like
                type_to_use = set
            else:
                # default to list-like
                type_to_use = list
            # create a placeholder list to store the iterable processed items
            processed_item_placeholder = []
            # process the items and add them to the list
            for item in item_to_process:
                processed_item_placeholder.append(_pretty_string_factory_object_processor(item))
            # return the iterator as either a list, a set or a tuple
            processed_item = type_to_use(processed_item_placeholder)
    else:
        # return the item as is
        processed_item = item_to_process
    return processed_item


def _pretty_string_factory_string_processor(item_to_print: Any, indent: int, pretty_string_lines: list[str], current_indent: int = 0) -> list[str]:
    """
    {'a': {'foo': 'bar'}, 'b': {'lol': 'kekw', 'hehe': 'haha'}, 'c': {}}
    =>
    {
        'a': {
            'foo': 'bar'
        },
        'b': {
            'lol': 'kekw',
            'hehe': 'haha'
        },
        'c': {}
    }
    """
    if type(item_to_print) is dict:
        # the item is a dict
        if not item_to_print:
            # if the dict is empty, add "{}" to the last line
            pretty_string_lines[-1] += "{}"
        else:
            # the dict is not empty, open a new dict
            pretty_string_lines[-1] += "{"
            dict_first_item = True
            for key, value in item_to_print.items():
                # for each item in the dict...
                if not dict_first_item:
                    # if this is not the first dict item,
                    # add a comma at the end of the last line
                    pretty_string_lines[-1] += ","
                else:
                    dict_first_item = False
                # add a new key/value line to pretty_string_lines
                pretty_string_lines.append(" "*(current_indent + indent) + f"{repr(key)}: ")
                # let _pretty_string_factory_string_processor cook
                pretty_string_lines = _pretty_string_factory_string_processor(
                    value,
                    indent,
                    current_indent = current_indent + indent,
                    pretty_string_lines = pretty_string_lines
                )
            # close the dict
            pretty_string_lines.append(" "*current_indent + "}")
    elif type(item_to_print) in [list, tuple, set]:
        # the item is an "openable" iterable
        if not item_to_print:
            # if the iterable is empty, add it as is to the last line
            pretty_string_lines[-1] += repr(item_to_print)
        else:
            # the iterable is not empty
            pretty_string_lines[-1] += repr(item_to_print)[0]
            iterable_first_item = True
            for item in item_to_print:
                # for each item in the iterable...
                if not iterable_first_item:
                    # if this is not the first item,
                    # add a comma at the end of the last line
                    pretty_string_lines[-1] += ","
                else:
                    iterable_first_item = False
                # add a new item line to pretty_string_lines
                pretty_string_lines.append(" "*(current_indent + indent))
                # let _pretty_string_factory_string_processor cook
                pretty_string_lines = _pretty_string_factory_string_processor(
                    item,
                    indent,
                    current_indent = current_indent + indent,
                    pretty_string_lines = pretty_string_lines
                )
            # close the iterable
            pretty_string_lines.append(" "*current_indent + repr(item_to_print)[-1])
    else:
        # the item is a string-like, add it as is to the last line
        pretty_string_lines[-1] += repr(item_to_print)
    return pretty_string_lines


def pretty_string_factory(dict_to_print: dict, indent: int = 4) -> str:
    """
    Return a pretty string for the __str__ method of DotDict.
    """
    # process dict_to_print into a simpler form
    # create a pretty string from the processed dict
    pretty_string_lines = _pretty_string_factory_string_processor(
        item_to_print = _pretty_string_factory_object_processor(dict_to_print),
        indent = indent,
        pretty_string_lines = [""]
    )
    return "\n".join(pretty_string_lines)


class DotDict(dict):
    """
    This class allows handling dictionaries with the "dot" notation.

    - set/get/delete items/attributes with the dot notation as well as the dict notation
        (dotdict.atr is the same as dotdict["atr"])
    - Direct link between DotDict and dict (DotDict inherits directly from dict, so it can
        do anything dict already can)
    - DotDict is recursive (dotdict.atr.subatr is the same as dotdict["atr"]["subatr"])
    - DotDict will raise exceptions when the keys cannot be accepted as attribute names
        (an attribute name cannot begin by a digit, but a dict key can)
    => The accepted names for the attributes must begin by an uppercase or lowercase letter,
    and cannot contain non-alphanumeric characters ("/w" from RegEx).
    - dir(dotdict_object) contains the keys/attributes of the underlying dictionary
    - adding DotDict objects as a DotDict attributes will work as intended (the underlying
        dictionary will receive a dict as a value)
    - create an empty DotDict with "DotDict()"
    - cannot be used with the __dict__ attribute, as well as the 'vars' built-in function
    """

    def __init__(self,
                 *args,
                 _check: bool = True,
                 _root: Optional[DotDict] = None,
                 _path_to_root: Optional[list[str]] = None,
                 **kwargs):
        # print("__init__ call")
        # create a temporary dict from the arguments
        dict_self = dict(*args, **kwargs)
        if _check:
            # if any values are mappings, convert them to dict, recursively
            dict_self = clean_types(dict_self)
            # test if all keys are valid as attribute names, recursively
            check_keys(dict_self)
        # init the "self" dict with the cleaned dict
        dict.__init__(self, dict_self)
        # add a reference to the root DotDict
        # bypass DotDict.__setattr__ to protect the variable from rewrites
        object.__setattr__(self, "_root", _root)
        # remember how to get to this DotDict from the root DotDict as a list of attribute names
        # bypass DotDict.__setattr__ to protect the variable from rewrites
        object.__setattr__(self, "_path_to_root", _path_to_root)

    def __getitem__(self, key: str) -> Any:
        # print("__getitem__ call")
        # check if the key exists
        if not (key in self.keys()):
            raise AttributeError(f"No key/attribute '{key}'")
        # get the value from the dictionary
        value = dict.__getitem__(self, key)
        # if the value is a dict, return it as a DotDict object
        if type(value) is dict:
            if self._root is None:
                # this DotDict is the root
                root = self
                # create the _path_to_root attribute
                path_to_root = [key]
            else:
                # add a reference to the root DotDict
                root = self._root
                # add the key to the _path_to_root attribute
                path_to_root = self._path_to_root + [key]
            # no need to check it, it's already cleared
            return DotDict(
                value,
                _check=False,
                _root=root,
                _path_to_root=path_to_root
            )
        else:
            return value

    # the logic for __getattr__ is the exact same as the one for __getitem__
    __getattr__ = __getitem__

    def __setitem__(self, key: str, value: Any):
        # print("__setitem__ call")
        # check if the key is valid as an attribute name
        check_key(key)
        # if the value is a mapping, convert it to DotDict (clears/cleans it)
        if is_mapping(value):
            value = DotDict(value)
        # if the value is a DotDict, insert it as a dict (already cleared)
        if type(value) is DotDict:
            value = dict(value)
        # insert the value to both this object and the root object, if it exists
        dict.__setitem__(self, key, value)
        if not (self._root is None):
            # retrieve the dictionary pointed by self._path_to_root
            dict_to_modify = dict(self._root)
            for breadcrumb in self._path_to_root:
                dict_to_modify = dict_to_modify[breadcrumb]
            # insert the value to the root dictionary
            dict_to_modify[key] = value

    # the logic for __setattr__ is the exact same as the one for __setitem__
    __setattr__ = __setitem__

    def __delitem__(self, key: str):
        # print("__delitem__ call")
        # check if the key exists
        if not (key in self.keys()):
            raise AttributeError(f"No key/attribute '{key}'")
        dict.__delitem__(self, key)

    # the logic for __delattr__ is the exact same as the one for __delitem__
    __delattr__ = __delitem__

    # overridden to show the keys as attributes with the 'dir' built-in function
    def __dir__(self) -> list[str]:
        # print("__dir__ call")
        dict_dir = dict.__dir__(self)
        dotdict_attributes = list(self.keys())
        return dict_dir + dotdict_attributes

    # for consistency with the 'dict.copy' method
    def copy(self) -> DotDict:
        """
        Returns a shallow copy of this DotDict object.
        """
        # print("copy call")
        return DotDict(dict(self))

    # for compatibility with the 'vars' built-in function
    @property
    def __dict__(self) -> MappingProxyType:
        # print("__dict__ call")
        # return a MappingProxyType to enhance the fact that this isn't
        # the right way to modify attributes of DotDict objects
        return MappingProxyType(dict(self))

    def __str__(self):
        """

        """
        # print("__str__ call")
        return pretty_string_factory(dict(self))


if __name__ == "__main__":
    # tests
    test = DotDict()
    # print(is_iterable_not_string_like("lol"))
    # print(is_iterable_not_string_like([1,2,3]))
    # print(is_iterable_not_string_like(["lol", "haha"]))
    # print(is_iterable_not_string_like("lol"))
    print(is_iterable_not_string_like(set()))
    print(str(set()))

    print(_pretty_string_factory_object_processor(("lol", "haha")))
    print(_pretty_string_factory_object_processor("lol"))
    print(_pretty_string_factory_object_processor({"lol", "haha"}))
    print(_pretty_string_factory_object_processor({"0": 1}))
    print(_pretty_string_factory_object_processor({
        "a": {
            "lol": "haha",
            "abc": "def"
        },
        "b": 5
    }))
