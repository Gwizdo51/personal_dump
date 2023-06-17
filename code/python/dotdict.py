from __future__ import annotations
import re
from typing import Optional, Any
from types import MappingProxyType
import json


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


# best attempt at defining a Regular Expression for an attribute name
attribute_name_pattern_string = "^[a-zA-Z]\w*$"
attribute_name_pattern = re.compile(attribute_name_pattern_string)
# dict class methods names
dict_attribute_names = [meth_name for meth_name in dir(dict) if not ("_" in meth_name)]


def check_key(key):
    # check if the key is a string
    if not (type(key) is str):
        raise KeyTypeError(f"The key '{key}' is not a string")
    # check if the key is accessible as a not-hidden attribute
    if not attribute_name_pattern.match(key):
        raise AttributeNameError(f"The key '{key}' is not valid as a DotDict attribute name")
    # check whether the key would erase a dict method
    if key in dict_attribute_names:
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
    nested dictionaries to DotDicts when they are dicts.
    """
    # placeholder for the clean dict
    cleaned_dict = {}
    for key in dict_to_check.keys():
        value = dict_to_check[key]
        # convert the value to a dict if it is a DotDict
        if type(value) is DotDict:
            value = dict(value)
        # clean the types of the value if it is a dict
        if type(value) is dict:
            value = clean_types(value)
        # add the clean value to the clean dict
        cleaned_dict[key] = value
    # return the clean dict
    return cleaned_dict


# def pretty_string_factory_recursive(dict_to_print: dict, indent: int = 2, current_indent: int = 0) -> list[str]:
#     """
#     Helper recursive function for pretty_string_factory.
#     """
#     # see if items are iterable with "iter"
#     # see if items are mappings with "dict" (mappings are iterable)
#     for key, value in dict_to_print.items():
#         current_indent += 2
#         ...
#     # return pretty_string
#     return "LOL"


# def pretty_string_factory(dict_to_print: dict, indent: int = 2) -> str:
#     """
#     Return a pretty string for the __str__ method of DotDict.
#     """
#     ...
#     return "LOL"


class DotDict(dict):
    """
    Allows handling dictionaries with the "dot" notation.

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
            # test if all keys are valid as attribute names, recursively
            check_keys(dict_self)
            # if any values are DotDicts, convert them to dict, recursively
            dict_self = clean_types(dict_self)
        # init the "self" dict with the cleaned dict
        dict.__init__(self, dict_self)
        # add a reference to the root DotDict
        # bypass DotDict.__setattr__ to protect the variable from rewrites
        object.__setattr__(self, "_root", _root)
        # remember how to get to this DotDict from the root DotDict as a list of attribute names
        # bypass DotDict.__setattr__ to protect the variable from rewrites
        object.__setattr__(self, "_path_to_root", _path_to_root)
        # print("root:", self._root)
        # print("root type:", type(self._root))
        # print("path to root:", self._path_to_root)

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
        # if the value is a dict, convert it to DotDict (clears/cleans it)
        if type(value) is dict:
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
        # return a MappingProxyType to enhance the fact that this isn't
        # the right way to modify attributes of DotDict objects
        return MappingProxyType(dict(self))

    # def __str__(self):
    #     """

    #     """
    #     # Deleguate the string to json.dumps when possible, otherwise
    #     # try to return a pretty string.
    #     try:
    #         raise Exception
    #         json_like_string = json.dumps(dict(self), indent=2)
    #     except:
    #         json_like_string = pretty_string_factory(dict(self))
    #     return json_like_string

if __name__ == "__main__":
    # tests
    test = DotDict()
