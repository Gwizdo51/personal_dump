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

## Strings

```C
char my_string[20];
char *my_other_string;
// my_string = "A great string"; // Doesn't work
strcpy(my_string, "A great string");
my_other_string = "An other great string";
```

## Arrays

list of items

```C
int int_array[10]; // arrays
int int_matrix[10][10]; // matrices
```

## Pointers

Variables that point to a memory address

```C
int value = 33;
int *addr = &value; // &<variable> returns the memory address of the variable
```

empty pointer: `NULL`

## Structures

Some OOP -> structures that hold other variables

```C
struct Rational {
    int numerator;
    int denominator;
};

// access elements directly
struct Rational my_rational;
my_rational.numerator = 15;

// access elements through memory address (requires "malloc")
struct Rational *my_rational_pointer;
my_rational_pointer->denominator = 7;
```

## Keywords

### define

Macro definition, used to define variables outside of functions (global constant, invariable) -> always written in **UPPERCASE**

**syntax**:
- `#define CNAME value`
- `#define CNAME (expression)`

```C
#define NAME "TechOnTheNet.com"
#define AGE 10

// define the BOOL type
#define BOOL int
#define FALSE 0
#define TRUE 1
```

### typedef

Used to define structures as types

```C
struct _Rational {
    int numerator;
    int denominator;
};
typedef struct _Rational Rational;
Rational my_rational;
```
<=>
```C
typedef struct _Rational {
    int numerator;
    int denominator;
} Rational;
Rational my_rational;
```

## Enumeration

Used to define a given number of possible states

```C
enum LifeCycleState {
    INITIALIZED, STARTED, STOPPED, DESTROYED
};
enum LifeCycleState currentState = INITIALIZED;
currentState = STARTED;
currentState = STOPPED;
currentState = INITIALIZED;
currentState = DESTROYED;
```

defined in `<stdlib.h>`:
```C
enum ExitState {
    EXIT_SUCCESS, EXIT_FAILURE
};
```

## Constants

Constants are global variables that can't be modified by functions

```C
const double MY_PI = 3.14159265;
const unsigned int ARRAY_SIZE = 5;
```

# Operators

## Arithmetic

- `+` : add 2 ints / floats
- `-` : substract 2 ints / floats
- `*` : multiply 2 ints / floats
- `/` : divide 2 ints / floats -> can be used to get the quotient of the euclidean division between 2 ints
- `%` : rest of euclidean division between 2 ints / floats

## Bitwise

- `&` : AND
- `|` : OR
- `^` : XOR
- `~` : NOT
- `<<` : moves to the left (`0b0010 << 2` == `0b1000`)
- `>>` : moves to the right (`0b1000 >> 2` == `0b0010`)

## Comparison

- `<` : ... is less than ...
- `<=` : ... is less or equal than ...
- `>` : ... is more than ...
- `>=` : ... is more or equal than ...
- `==` : ... is equal to ...
- `!=` : ... is not equal to ...

## Logic

- `&&` : AND
- `||` : OR
- `!` : NOT

## Assignment

- `a = 5` : assign
- `a += 5` : adds and assign
- `a -= 5` : substract and assign
- `a *= 5` : multiply and assign
- `a  /= 5` : divide and assign
- `a %= 5` : modulus and assign
- `a &= 5` : bitwise AND and assign
- `a |= 5` : bitwise OR and assign
- `a ^= 5` : bitwise XOR and assign
- `a <<= 5` : bitwise left move and assign
- `a >>= 5` : bitwise right move ans assign
- `a++` : increment by one and assign
- `a--` : decrement by one and assign

Assignments are operations; they return the result:
- `printf("%d", b = 5);` will print `5`
- `a = b = c = 5;` works, and assigns `5` to `c`, then `b`, then `a`

## Cast

# Functions

## printf

syntax:
- `printf(const char *format, ...);`
- `printf("%d\n", my_int);`

-> to print the "%" char: `printf("%%");`

format syntax: `%[flags][width][.precision][length]specifier`
- **specifier**: the type of variable to print
    - `c` : character
    - `d` or `i` : signed integer
    - `u` : unsigned integer
    - `e` or `E` : exponential notation
    - `f` : decimal floating point
    - `g` : shorter of `e` or `f`
    - `G` : shorter of `E` or `f`
    - `o` : signed octal
    - `s` : string
    - `x` : unsigned hexadecimal integer
    - `X` : same with capital letters
    - `p` : pointer address
- **flags**:
    - `-` : left adjust with the width given (right adjust is the default)
    - `+` : write a + for positive numbers (minus for negative is always there)
    - `(space)` : leave a space in place of the + sign for positive numbers
    - `#` : writes the number as it would be in the code (preceded with `0x` for hexadecimals, ...)
    - `0` : left pads number with zeros with the width specified
- **width**:
    - `(number)` : minimum number of characters to print; pads with blank spaces, does not truncate
    - `*` : width not specified here but as an additional argument preceding the value to format
- **.precision**:
    - `.(number)` : (default is 1)
        - for integers (d, i, o, u, x, X): padding with zeros
        - for floats (e, E and f): number of digits after the decimal point
        - for g and G: maximum number of significant digits
        - for s: maximum number of characters to be printed
    - `.*` : precision not specified here but as an additional argument preceding the value to format
- **length**:
    - `h` :
        - for integers: argument interpreted as a short int or unsigned short int
    - `l` :
        - for integers: argument interpreted as a long int or unsigned long int
        - for characters and strings: argument interpreted as a wide character or wide character string
    - `L` :
        - for floats: argument interpreted as a long double

# Macros

# Ressources

- https://www.koor.fr/
- https://en.cppreference.com/
