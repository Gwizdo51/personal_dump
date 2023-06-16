import re
from typing import Optional, Any


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


def check_key(key):
    # check if the key is a string
    if not (type(key) is str):
        raise KeyTypeError(f"The key '{key}' is not a string")
    # check if the key is accessible as a not-hidden attribute
    if not attribute_name_pattern.match(key):
        raise AttributeNameError(f"The key '{key}' cannot be used as an attribute name")


def check_keys(dict_to_check: dict):
    """
    Recursively checks if the keys of dict_to_check and its
    nested dictionaries are accessible as attribute names.
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


class DotDict(dict):
    """
    Allows handling dictionaries with the "dot" notation.
    """

    def __init__(self, *args, _check: bool = True, **kwargs):
        if _check:
            # create a temporary dict from the arguments
            dict_self = dict(*args, **kwargs)
            # test if all keys are valid as attribute names, recursively
            check_keys(dict_self)
            # if any values are DotDicts, convert them to dict, recursively
            dict_self = clean_types(dict_self)
            # init the "self" dict with the cleaned dict
            dict.__init__(self, dict_self)
        else:
            # init the "self" dict from the arguments directly
            dict.__init__(self, *args, **kwargs)

    def __getitem__(self, key: str) -> Optional[Any]:
        # check if the key exists
        if not (key in self.keys()):
            raise AttributeError(f"No key/attribute '{key}'")
        value = dict.__getitem__(self, key)
        if type(value) is dict:
            # if the value is a dict, return it as a DotDict object
            # no need to check it, it's already cleared
            return DotDict(value, _check=False)
        else:
            return value

    __getattr__ = __getitem__

    def __setitem__(self, key: str, value: Optional[Any]):
        # check if the key is valid as an attribute name
        check_key(key)
        # if the value is a dict, convert it to DotDict (clears/cleans it)
        if type(value) is dict:
            value = DotDict(value)
        # if the value is a DotDict, insert it as a dict (already cleared)
        if type(value) is DotDict:
            value = dict(value)
        dict.__setitem__(self, key, value)

    __setattr__ = __setitem__

    def __delitem__(self, key: str):
        # check if the key exists
        if not (key in self.keys()):
            raise AttributeError(f"No key/attribute '{key}'")
        dict.__delitem__(self, key)

    __delattr__ = __delitem__

    def __dir__(self) -> list[str]:
        # overridden to show the keys as attributes with the 'dir' built-in function
        dict_dir = dict.__dir__(self)
        dotdict_attributes = list(self.keys())
        return dict_dir + dotdict_attributes


if __name__ == "__main__":
    # tests
    pass
