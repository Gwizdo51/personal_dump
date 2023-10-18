# Types and variables

## init a variable

```
type variableName;
type variableName = initialValue;
```

## types available

- numerical types (unsigned are always positive):
    - `char` (~1 byte)
    - `short` (~2 bytes)
    - `int` (~4 bytes)
    - `long` (~8 bytes)
    - `unsigned char`
    - `unsigned short`
    - `unsigned int`
    - `unsigned long`
- decimal types (always signed):
    - `float` (~4 bytes)
    - `double` (~8 bytes)
- characters: no difference between an integer written with a byte and a character

## Constants

i.e. `1234` or `0.25`

- **integers**: always typed `int` -> to get a `long`: add `L` at the end: `10000000000L`
- **floats**: always typed `double` -> to get a `float`: add `f` at the end: `1.25f`
- **octal**: `0104`
- **hexadecimal**: `0xff`
