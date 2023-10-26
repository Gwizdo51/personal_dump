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

// access elements through memory address
struct Rational *my_rational_pointer;
my_rational_pointer->denominator = 7;
```

## Keywords

### define

Macro definition, used to define variables outside of functions (global constant, invariable) -> always written in UPPERCASE

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

## arithmetic

- **+** : add 2 ints / floats
- **-** : substract 2 ints / floats
- **\*** : multiply 2 ints / floats
- **/** : divide 2 ints / floats -> can be used to get the quotient of the euclidean division between 2 ints
- **%** : rest of euclidean division between 2 ints / floats

# Functions

## printf

syntax:
- `printf(const char *format, ...);`
- `printf("%d\n", my_int);`

-> to print the "%" char: `printf("%%");`

format syntax: `%[flags][width][.precision][length]specifier`
- **specifier**: the type of variable to print
    - `c`: character
    - `d` or `i`: signed integer
    - `u`: unsigned integer
    - `e` or `E`: exponential notation
    - `f`: decimal floating point
    - `g`: shorter of `e` or `f`
    - `G`: shorter of `E` or `f`
    - `o`: signed octal
    - `s`: string
    - `x`: unsigned hexadecimal integer
    - `X`: same with capital letters
    - `p`: pointer address
- **flags**:
- **width**:
- **.precision**:
- **length**:

# Macros

# Ressources

- https://www.koor.fr/
- https://en.cppreference.com/
