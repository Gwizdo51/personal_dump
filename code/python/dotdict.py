from __future__ import annotations
import re
from typing import Optional, Any, Union
from types import MappingProxyType
from collections.abc import Mapping, Iterator, ItemsView, ValuesView, KeysView


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


def is_mapping(obj: Any) -> bool:
    """
    Returns whether an object is a mapping of some kind.

    PARAMETERS
    ----------
    obj: Any
        The object to analyse.

    RETURNS
    -------
    bool
        Whether the object is a mapping of any kind.
    """
    return isinstance(obj, Mapping)


def is_iterable_not_string_like(obj: Any) -> bool:
    """
    Returns whether an object is an iterable, but not string-like
    (this function will return False if the object type is "str", "bytes"
    or "bytearray").

    PARAMETERS
    ----------
    obj: Any
        The object to analyse.

    RETURNS
    -------
    bool
        Whether obj is an iterable, but not a string-like.
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
CLASS_ATTRIBUTE_NAME_PATTERN = re.compile(r"^[a-zA-Z]\w*$")
# dict class method names
DICT_METHOD_NAMES = [meth_name for meth_name in dir(dict) if not ("_" in meth_name)]


def check_key(key: Any):
    """
    Helper function for the DotDict class.
    Raises exceptions when a key is not a string, is not valid
    as as class attribute name, or woud erase a "dict" class method.

    PARAMETERS
    ----------
    key: Any
        The key to analyse.

    RAISES
    ------
    KeyTypeError
        Raised when the key is not a string.
    AttributeNameError
        Raised when the key is not valid as a class attribute name.
    AttributeNameError
        Raised when the key would erase a "dict" class method (like "get" or "update").
    """
    # check if the key is a string
    if not isinstance(key, str):
        raise KeyTypeError(f"The key '{key}' is not a string")
    # check if the key is accessible as a visible attribute
    if not CLASS_ATTRIBUTE_NAME_PATTERN.match(key):
        raise AttributeNameError(f"The key '{key}' is not valid as a class attribute name")
    # check whether the key would erase a dict method
    if key in DICT_METHOD_NAMES:
        raise AttributeNameError(f"The key '{key}' would overwrite a dict method")


def check_keys(dict_to_check: dict):
    """
    Helper function for the DotDict class.
    Recursively checks if the keys of dict_to_check and its nested dictionaries
    are strings, are accessible as attribute names, and will not replace
    any methods from the "dict" class.

    PARAMETERS
    ----------
    dict_to_check: dict
        The dictionary to analyse.
    """
    for key in dict_to_check.keys():
        check_key(key)
        # if the value is a dict, check for its keys as well
        value = dict_to_check[key]
        if isinstance(value, dict):
            check_keys(value)


def clean_types(dict_to_check: dict) -> dict:
    """
    Helper function for the DotDict class.
    Recursively converts the types of all the values of dict_to_check and its
    nested mappings to "dict" when they are mappings of any kind.

    PARAMETERS
    ----------
    dict_to_check: dict
        The dictionary which values types need to be converted
        to dict when they are mappings of any kind.

    RETURNS
    -------
    dict
        The dictionary with "cleaned" values types.
    """
    # placeholder for the clean dict
    cleaned_dict = {}
    for key in dict_to_check.keys():
        value = dict_to_check[key]
        # convert the value to a dict if if is a mapping of any kind
        if is_mapping(value):
            value = dict(value)
        # clean the types of the value's nested mappings if it is a dict
        if isinstance(value, dict):
            value = clean_types(value)
        # add the clean value to the clean dict
        cleaned_dict[key] = value
    # return the clean dict
    return cleaned_dict


def _pretty_string_factory_object_processor(item_to_process: Any) -> Any:
    """
    Helper function for the pretty_string_factory function.
    Returns a simpler form of an item and its content:
    - all mappings and nested mappings are converted to the "dict" type;
    - all iterable that are not string-like are converted to either lists,
    sets or tuples;
    - all other items are left as is.
    item_to_process is left untouched; The returned item is an image.

    PARAMETERS
    ----------
    item_to_process: Any
        The item to process into a simpler form.

    RETURNS
    -------
    Any
        The processed, "simpler" item.
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
    Helper function for the pretty_string_factory function.
    Handles the creation of the pretty string itself.
    item_to_print needs to be a "clean" item, as defined by the
    _pretty_string_factory_object_processor function.

    PARAMETERS
    ----------
    item_to_print: Any
        Any object, but must be "clean", as defined by the
        _pretty_string_factory_object_processor function.
    indent: int
        The number of spaces used per indent level.
    pretty_string_lines: list[str]
        The list containing the current lines of the pretty string.
    current_indent: int = 0
        The current indent for this nest level.

    RETURNS
    -------
    list[str]
        The list of lines of the pretty string.
    """
    if isinstance(item_to_print, dict):
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
    elif isinstance(item_to_print, (list, tuple, set)):
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
    Creates a pretty string from a dictionary.
    The string returned matches the output of "json.loads(dict_to_print, indent=indent)",
    but should not fail if it encounters unexpected types.

    PARAMETERS
    ----------
    dict_to_print: dict
        The dictionary to pretty-print.
    indent: int = 4
        The number of spaces to use per indent level.

    RETURNS
    -------
    str
        The JSON-like indented string representing dict_to_print.
    """
    # process dict_to_print into a simpler form
    # create a pretty string from the processed dict
    pretty_string_lines = _pretty_string_factory_string_processor(
        item_to_print = _pretty_string_factory_object_processor(dict_to_print),
        indent = indent,
        pretty_string_lines = [""]
    )
    return "\n".join(pretty_string_lines)


def get_view(dotdict: DotDict) -> dict[str, Any]:
    """
    Returns a version of the dictionary of a DotDict object where
    its values are converted to DotDict when they are of the "dict" type.

    PARAMETERS
    ----------
    dotdict: DotDict
        The DotDict object to get the processed view from.

    RETURNS
    -------
    dict[str, Any]
        The processed dictionary.
    """
    # get the dict from the dotdict object
    dict_to_view = dict(dotdict)
    # if a value is a dict, convert it to the DotDict object
    for key, value in dict_to_view.items():
        if isinstance(value, dict):
            # replace the value with dotdict[key] to let DotDict.__getitem__
            # handle the DotDict object hidden attributes
            dict_to_view[key] = dotdict[key]
    return dict_to_view


class DotDictItems:
    """
    Provides a dynamic view of the DotDict's items. Works the same way as
    "dict_items" works, except that the nested dictionaries are viewed as
    DotDicts objects.
    """

    def __init__(self, mapping):
        # prevent direct DotDictItems instance creation
        raise TypeError(f"cannot create '{self.__class__.__name__}' instances")


# inherit from collections.abc.ValueView for the sole purpose of having
# "issubclass(DotDictValues, ValuesView)"
# evaluate to True
class DotDictValues(ValuesView):
    """
    Provides a dynamic view of the DotDict's values. Works the same way as
    "dict_values" works, except that the nested dictionaries are viewed as
    DotDicts objects. Inherits from collections.abc.ValueView for the sole
    purpose of having
    "issubclass(DotDictValues, ValuesView)"
    evaluate to True.
    """

    def __new__(cls, _dotdict_hook: DotDict, /) -> DotDictValues:
        print("DotDictValues __new__ call") if _dotdict_hook._verbose else ...
        values_view_obj = object.__new__(cls)
        # store the DotDict object to view the values of in self._dotdict
        # bypass DotDictValues.__setattr__, which is meant to fail
        object.__setattr__(values_view_obj, "_dotdict_hook", _dotdict_hook)
        return values_view_obj

    def __init__(self, *_, **__):
        print("DotDictValues __init__ call") if self._dotdict_hook._verbose else ...
        # prevent direct DotDictValues instance creation
        raise TypeError(f"cannot create '{self.__class__.__name__}' instances")

    def __iter__(self) -> Iterator:
        print("DotDictValues __iter__ call") if self._dotdict_hook._verbose else ...
        # return an iterator over the values of the associated DotDict object
        return iter(self._dotdict_hook._view.values())

    def __reversed__(self) -> Iterator:
        print("DotDictValues __reversed__ call") if self._dotdict_hook._verbose else ...
        # returns a generator that returns the values
        # in the opposite order of insertion
        return iter(reversed(self._dotdict_hook._view.values()))

    def __len__(self) -> int:
        print("DotDictValues __len__ call") if self._dotdict_hook._verbose else ...
        return len(self._dotdict_hook)

    @property
    def mapping(self) -> MappingProxyType:
        print("DotDictValues mapping call") if self._dotdict_hook._verbose else ...
        return MappingProxyType(self._dotdict_hook)

    def __contains__(self, item: Any, /) -> bool:
        print("DotDictValues __contains__ call") if self._dotdict_hook._verbose else ...
        # returns True when item is in the values of self._dotdict_hook
        return item in self._dotdict_hook._view.values()

    def __str__(self) -> str:
        # leninent
        print("DotDictValues __str__ call") if self._dotdict_hook._verbose else ...
        return repr(self)

    def __repr__(self) -> str:
        # strict
        print("DotDictValues __repr__ call") if self._dotdict_hook._verbose else ...
        return f"{self.__class__.__name__}({str(list(self._dotdict_hook._view.values()))})"

    # def __or__(self):
    #     raise NotImplementedError

    # def __ror__(self):
    #     raise NotImplementedError

    def __getattr__(self, *_, **__):
        print("DotDictValues __getattr__ call") if self._dotdict_hook._verbose else ...
        raise AttributeError(f"Access to {self.__class__.__name__} attributes denied")

    def __setattr__(self, *_, **__):
        print("DotDictValues __setattr__ call") if self._dotdict_hook._verbose else ...
        raise AttributeError(f"Access to {self.__class__.__name__} attributes denied")

    def __delattr__(self, *_, **__):
        print("DotDictValues __delattr__ call") if self._dotdict_hook._verbose else ...
        raise AttributeError(f"Access to {self.__class__.__name__} attributes denied")


# make MappingProxyType return nested dicts as DotDict objects
# => add a "_view" attribute that holds a copy of DotDict, but with
# any value converted to DotDict when they are dicts


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
                 _verbose: bool = False,
                 **kwargs):
        """
        The instance factory.

        PARAMETERS
        ----------
        _check: bool = True
            Whether to check the keys of the dictionary.
        _root: DotDict | None = None
            The root DotDict object.
        _path_to_root: list[str] | None = None
            The keys that lead to this object from the root object.
        _verbose: bool = False
            Print stuff, mostly method calls. For debug purposes.
        """
        print("__init__ call") if _verbose else ...
        # create a temporary dict from the arguments
        # -> this creates a shallow copy of the original dict
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
        # for debug purposes
        object.__setattr__(self, "_verbose", _verbose)

    def __getitem__(self, key: str, /) -> Any:
        """
        Get an item from the DotDict.
        Called with the dot notation as well as the dict notation.

        PARAMETERS
        ----------
        key: str
            The key/attribute of the item to get.

        RETURNS
        -------
        Any
            The value of the item.

        RAISES
        ------
        AttributeError
            Raised when the key/attribute does not exist.
        """
        print("__getitem__ call") if self._verbose else ...
        # check if the key exists
        if not (key in self.keys()):
            raise AttributeError(f"No key/attribute '{key}'")
        # get the value from the dictionary
        value = dict.__getitem__(self, key)
        # if the value is a dict, return it as a DotDict object
        if isinstance(value, dict):
            if self._root is None:
                # this DotDict is the root
                root = self
                # create the _path_to_root attribute
                path_to_root = [key]
            else:
                # add a reference to the root DotDict
                root = self._root
                # add the key to the _path_to_root attribute
                path_to_root = self._path_to_root.append(key)
            # no need to check it, it's already cleared
            return DotDict(
                value,
                _check=False,
                _root=root,
                _path_to_root=path_to_root,
                _verbose=self._verbose
            )
        else:
            return value

    # the logic for __getattr__ is the exact same as the one for __getitem__
    __getattr__ = __getitem__

    def __setitem__(self, key: str, value: Any, /):
        """
        Set an item.
        Called with the dot notation as well as the dict notation.

        PARAMETERS
        ----------
        key: str
            The key/attribute of the item to set.
        value: Any
            The value of the item to set.
        """
        print("__setitem__ call") if self._verbose else ...
        # check if the key is valid as an attribute name
        check_key(key)
        # if the value is a mapping, convert it to DotDict (clears/cleans it)
        if is_mapping(value):
            value = DotDict(value)
        # if the value is a DotDict, insert it as a dict (already cleared)
        if isinstance(value, DotDict):
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

    def __delitem__(self, key: str, /):
        """
        Delete an item from the DotDict.
        Called with the dot notation as well as the dict notation.

        PARAMETERS
        ----------
        key: str
            The key/attribute of the item to delete.

        RAISES
        ------
        AttributeError
            Raised when the key/attribute does not exist.
        """
        print("__delitem__ call") if self._verbose else ...
        # check if the key exists
        if not (key in self.keys()):
            raise AttributeError(f"No key/attribute '{key}'")
        # delete the item from both this object and the root object, if it exists
        dict.__delitem__(self, key)
        if not (self._root is None):
            # retrieve the dictionary pointed by self._path_to_root
            dict_to_modify = dict(self._root)
            for breadcrumb in self._path_to_root:
                dict_to_modify = dict_to_modify[breadcrumb]
            # delete the item from the root dictionary
            del dict_to_modify[key]

    # the logic for __delattr__ is the exact same as the one for __delitem__
    __delattr__ = __delitem__

    def __dir__(self) -> list[str]:
        """
        Overridden to show the keys as attributes with the 'dir' built-in function.

        RETURNS
        -------
        list[str]
            A list containing the names of all methods and key/attributes
            of this object.
        """
        # print("__dir__ call")
        dict_dir = dict.__dir__(self)
        dotdict_attributes = list(self.keys())
        return dict_dir + dotdict_attributes

    @property
    def __dict__(self) -> MappingProxyType:
        """
        For compatibility with the 'vars' built-in function.

        RETURNS
        -------
        MappingProxyType
            A mapping proxy representing the DotDict object.
        """
        print("__dict__ call") if self._verbose else ...
        # return a MappingProxyType to enhance the fact that this isn't
        # the right way to modify attributes of DotDict objects
        return MappingProxyType(self._view)

    def __str__(self) -> str:
        """
        Returns a "json.dumps"-like string representing the DotDict object.

        RETURNS
        -------
        str
            A string equivalent to the output of "json.dumps(dict(self), indent=4)".
        """
        # lenient
        print("__str__ call") if self._verbose else ...
        return pretty_string_factory(dict(self))

    def __repr__(self):
        # strict
        print("__repr__ call") if self._verbose else ...
        return f"{self.__class__.__name__}({dict.__repr__(self)})"

    def copy(self) -> DotDict:
        """
        Returns a shallow copy of this DotDict object.
        Overriden for consistency with the 'dict.copy' method.

        RETURNS
        -------
        DotDict
            A shallow copy of this object.
        """
        print("copy call") if self._verbose else ...
        # the copy returned must have the same hidden attributes
        return DotDict(
            dict(self),
            _check=False,
            _root=self._root,
            _path_to_root=self._path_to_root,
            _verbose=self._verbose
        )

    def clear(self):
        """
        Empties the DotDict.
        Overriden for consistency with the 'dict.clear' method.
        """
        print("clear call") if self._verbose else ...
        # clear this object and the same object in the root object, if it exists
        dict.clear(self)
        if not (self._root is None):
            # retrieve the dictionary pointed by self._path_to_root
            dict_to_modify = dict(self._root)
            for breadcrumb in self._path_to_root:
                dict_to_modify = dict_to_modify[breadcrumb]
            # delete the item from the root dictionary
            dict_to_modify.clear()

    def get(self, key: Any, default: Any = None, /) -> Any:
        """
        Get an item from the DotDict. If the item does not exist,
        return a default value.

        PARAMETERS
        ----------
        key: Any
            The key/attribute of the item to get.
        default: Any = None
            The value to return in case the item does not exist.

        RETURNS
        -------
        Any
            The value if the key exists, the default value otherwise.
        """
        print("get call") if self._verbose else ...
        # return the default value if the key doesn't exist
        if not (key in self.keys()):
            return default
        # use "__getitem__" to return the value otherwise
        return self[key]

    def items(self) -> DotDictItems:
        # Returns a dynamic view of the items of this DotDict.
        raise NotImplementedError

    def pop(self, key: Any, default: Any = None, /) -> Any:
        raise NotImplementedError

    def popitem(self) -> ...:
        raise NotImplementedError

    def setdefault(self, key: Any, default: Any = None, /) -> Any:
        raise NotImplementedError

    def update(self, *args, **kwargs):
        raise NotImplementedError

    def values(self) -> DotDictValues:
        print("values call") if self._verbose else ...
        # Returns a dynamic view of the values of this DotDict.
        return DotDictValues.__new__(DotDictValues, self)

    @property
    def _view(self) -> dict[str, Any]:
        """
        See "get_view" docstring.

        RETURNS
        -------
        dict
            A dict whose nested dicts are DotDicts.
        """
        print("_view call") if self._verbose else ...
        return get_view(self)


if __name__ == "__main__":
    # tests
    # test = DotDict()
    # print(is_iterable_not_string_like("lol"))
    # print(is_iterable_not_string_like([1,2,3]))
    # print(is_iterable_not_string_like(["lol", "haha"]))
    # print(is_iterable_not_string_like("lol"))
    # print(is_iterable_not_string_like(set()))
    # print(str(set()))

    # print(_pretty_string_factory_object_processor(("lol", "haha")))
    # print(_pretty_string_factory_object_processor("lol"))
    # print(_pretty_string_factory_object_processor({"lol", "haha"}))
    # print(_pretty_string_factory_object_processor({"0": 1}))
    # print(_pretty_string_factory_object_processor({
    #     "a": {
    #         "lol": "haha",
    #         "abc": "def"
    #     },
    #     "b": 5
    # }))

    test = DotDict({"a": {"b": "c"}})
    print(repr(test["a"].copy))
