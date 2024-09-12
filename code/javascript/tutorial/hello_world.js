"use strict";

// alert("hello world!");

// this is a single line comment

/* This is a comment
on multiple lines*/

/*
// variables
let message = "test message";
// console.log(message);

if (true) {
    let message = "haha";
    console.log(message);
}
console.log(message);
if (true) {
    message = "haha";
}
console.log(message);
message = 3;
console.log(message);
// */

// doesn't work in strict mode
// blbl = 6;

/*
// value types
let my_var;
// numbers
my_var = 123;
console.log(my_var);
console.log(typeof my_var);
my_var = 12.34;
console.log(my_var);
console.log(typeof my_var);
// special numbers
my_var = Infinity;
console.log(my_var);
console.log(typeof my_var);
my_var = 1 / 0; // doesn't crash
console.log(my_var);
console.log(typeof my_var);
my_var = -Infinity;
console.log(my_var);
console.log(typeof my_var);
my_var = NaN;
console.log(my_var);
console.log(typeof my_var);
my_var = "not a number" / 3;
console.log(my_var);
console.log(typeof my_var);
// big ints
// console.log(2**53);
// console.log(2**53 + 1);
console.log(`2**53 === 2**53 + 1 => ${2**53 === 2**53 + 1}`);
my_var = 123456789123456789123456789n;
console.log(my_var);
console.log(typeof my_var);
// strings
my_var = "this is a string";
console.log(my_var);
console.log(typeof my_var);
my_var = `this is a formatted string with a number: ${123}`;
console.log(my_var);
console.log(typeof my_var);
// booleans
my_var = true;
console.log(my_var);
console.log(typeof my_var);
my_var = false;
console.log(my_var);
console.log(typeof my_var);
// null
my_var = null;
console.log(my_var);
console.log(typeof my_var);
// undefined -> can be used to "unassign" a variable
my_var = undefined;
console.log(my_var);
console.log(typeof my_var);
// */

/*
// browser interactions
// alert("this is an alert");
// let prompt_answer = prompt("blablabla");
// let prompt_answer = prompt("blablabla", "default answer");
// console.log(prompt_answer);
let confirmed = confirm("U sure bruh?");
console.log(confirmed);
// */

/*
// type conversion
let value;
// to string
value = String(undefined);
console.log(value); console.log(typeof value);
// to number
value = Number("abc");
console.log(value); console.log(typeof value);
value = Number("  123   ");
console.log(value); console.log(typeof value);
value = Number("5.4");
console.log(value); console.log(typeof value);
value = Number("");
console.log(value); console.log(typeof value);
value = Number(null);
console.log(value); console.log(typeof value);
value = Number(undefined);
console.log(value); console.log(typeof value);
value = Number(true);
console.log(value); console.log(typeof value);
value = Number(false);
console.log(value); console.log(typeof value);
value = Boolean(1);
console.log(value); console.log(typeof value);
value = Boolean(-2.5);
console.log(value); console.log(typeof value);
value = Boolean(0);
console.log(value); console.log(typeof value);
value = Boolean(null);
console.log(value); console.log(typeof value);
value = Boolean(undefined);
console.log(value); console.log(typeof value);
value = Boolean("");
console.log(value); console.log(typeof value);
value = Boolean("ABC 123");
console.log(value); console.log(typeof value);
// */

/*
// operators
let a = 10, b = 3;
console.log(a + b);
console.log(a - b);
console.log(a * b);
console.log(a / b);
// remainder
console.log(a % b);
// power
console.log(a ** b);
// -> square root
console.log(9 ** (1/2));
// works on strings
console.log("Hello world" + "!");
// "+" converts to number
console.log(+true);
console.log(+"");
console.log(+undefined);
// affectations return the value assigned
console.log((a = 5) === 5);
// chain affectations
a = b = 6;
console.log(a);
console.log(b);
a += 1;
console.log(a);
a -= 2;
console.log(a);
a *= 3;
console.log(a);
a /= 5;
console.log(a);
// increment / decrement
a++;
console.log(a);
a--;
console.log(a);
// */

/*
// comparisons
console.log(2 > 1);
console.log(2 < 1);
console.log(2 >= 2);
console.log(2 <= 2);
console.log(2 == 1);
console.log(2 != 1);
console.log(0 == "0");
console.log(0 === "0");
console.log(0 != "0");
console.log(0 !== "0");
console.log(true == 1);
console.log(false == 0);
// */

/*
// "if" statements
let user_answer = prompt("enter number");
console.log(user_answer);
console.log(typeof user_answer);
// if (user_answer > 18) {
//     alert("positive");
// }
// else if (user_answer < 0) {
//     alert("negative");
// }
// else {
//     alert("zero");
// }
// ternary operator
// user_answer >= 0 ? alert("positive or zero") : alert("negative"); // bad idea
// let alertText = (user_answer >= 18) ? "Has access" : "Doesn't have access";
// alert(alertText);
// else if with ternary operator
// alertText = user_answer < 3 ? "baby" :
//     user_answer < 18 ? "young man" :
//     "old dude";
// alert(alertText);
// ?? operator: itself if defined (not "null" nor "undefined"), else provided value
let message = user_answer ?? Infinity;
console.log(message);
// */

/*
// switch case
let action = prompt("choose an action (switch, attack, flee)");
switch (action) {
    case "switch":
        console.log("switching pokemon");
        break;
    case "attack":
        console.log("attacking the opponent");
        break;
    // grouping cases for a logical OR
    case "flee":
    case "run":
        console.log("fleeing the battle");
        break;
    default:
        console.log("did not understand action");
}
// strict equality (types must match)
let value = 3;
switch (value) {
    case 0:
    case 1:
        console.log("doesn't show");
        break;
    case 2:
        console.log("doesn't show either");
        break;
    case "3":
        console.log("qmkdjf^r");
        break;
    default:
        console.log("this shows");
}
// */

/* boolean / logical operators
// AND
console.log(true && false);
// OR
console.log(true || false);
// NOT
console.log(!false);
// */

/* loops
// while loop
let index = 0;
while(index < 5) {
    console.log(index);
    index++;
}
// do while, useful if you want to enter at least once
do {
    console.log(index);
    index--;
}
while (index);
// for loop
// for (begin; condition; step)
for (index = -5; index < 10; index++) {
    console.log(index);
}
// break the loop
index = 0;
while (true) {
    console.log(index);
    index++;
    if (index == 5) {
        break;
    }
}
for (index = 0; index < 10; index++) {
    console.log(index);
    if (index == 5) {
        break;
    }
}
// skip this iteration
for (index = 0; index <= 10; index++) {
    if (index % 2 == 0) continue;
    console.log(index);
}
// loop labels
let index_line, index_column;
outer: for (index_line = 0; index_line < 5; index_line++) {
    for (index_column = 0; index_column < 5; index_column++) {
        console.log(`coordinates ${index_line} ${index_column}`);
        if ((index_line == 2) && (index_column == 4)) {
            console.log("found it! breaking out of both loops");
            break outer;
        }
    }
}
// */

/*
// functions
function displayHelloWorld() {
    console.log("Hello world!");
}
// "name" property contains the name of the function
console.log(displayHelloWorld.name); // displayHelloWorld
let anonymousFunction = function () {};
console.log(anonymousFunction.name); // anonymousFunction
// console.log((function() {}).name)
console.log((new Function()).name); // anonymous
// global variable
let sum = 0;
displayHelloWorld();
function add(a, b = 0) {
    sum = a + b;
    return sum;
}
console.log(add(5));
console.log(sum);
// parameters are local copies
let message = "Hello";
function displayMessage(message_param) {
    message_param += " world!";
    console.log(message_param);
}
displayMessage(message);
console.log(message);
// default return value is undefined
function doNothing() {}
console.log(doNothing() === undefined);
// function expressions
let my_function = function() {console.log("running my_function");};
my_function();
console.log(typeof my_function);
// passing functions as parameters
function ask(text, yes, no) {
    if (confirm(text)) {
        yes();
    }
    else {
        no();
    }
}
function showOK() {
    alert("you agreed");
}
function showCancel() {
    alert("you canceled");
}
ask("do you agree?", showOK, showCancel);
// */

/*
// arrow functions
let sum = (a, b) => a + b;
console.log(sum(2, 3));
let square = n => n**2;
console.log(square(4));
let sayHi = () => console.log("Hi there!");
sayHi();
// dynamic function definition
let userAge = 10;
let showGreetings = (userAge >= 18) ?
    () => console.log("Hello good sir!") :
    () => console.log("Hello young man!");
showGreetings();
// multiline
let sum2 = (a, b=0) => {
    let result = a + b;
    // debugger; // breakpoint in dev tools
    return result;
};
console.log(sum2(10));
// */

/*
// objects
// constructor
let object1 = new Object();
// literal
let object2 = {};
console.log(object1);
console.log(object2);
// create and initialise
let user = {
    name: "John",
    age: 30
};
console.log(user);
// access properties
console.log(user.name);
console.log(user["age"]);
let key = "name";
console.log(user[key]);
// add properties
user.isAdmin = true;
console.log(user);
// delete properties
delete user.isAdmin;
console.log(user);
// property value shorthand
let userName = "Arthur", age = 18;
user = {
    userName,
    age
};
console.log(user);
// numbers as property (sorted when looping)
let obj = {
    1: "haha",
    0: "lol"
};
console.log(obj);
console.log(obj[0]);
// property existence
console.log("name" in user);
console.log("userName" in user);
// loop through property names
for (key in user) {
    console.log(`${key}: ${user[key]}`);
}
for (key in obj) {
    console.log(`${key}: ${obj[key]}`);
}
// optional chaining
console.log(user.address); // undefined
// console.log(user.address.street); // error
console.log(user?.address?.street); // undefined
// show all keys
console.log(Object.keys(user));
// */

/*
// objects copying
let user1 = {
    name: "John"
};
let user2 = user1; // same object referenced by 2 variables
console.log(user1);
console.log(user2);
user1.name = "Henry"; // -> changes the "name" property for both objects
user2.age = "26";
console.log(user1);
console.log(user2);
// variables referencing objects are equal if they reference the same object
console.log(user1 === user2);
// shallow copy of an object
let new_user = {};
// method 1: loop through properties
for (const prop in user1) {
    new_user[prop] = user1[prop];
}
console.log(new_user);
// method 2: Object.assign
new_user = {};
Object.assign(new_user, user1);
console.log(new_user);
// -> can be used to add/overwrite the properties using those of other objects
let permission1 = {canRead: true};
let permission2 = {canWrite: false};
Object.assign(new_user, permission1, permission2);
console.log(new_user);
// Object.assign returns the modified object
new_user = Object.assign({}, user1);
console.log(new_user);
// deep cloning (nested cloning): structuredClone
let element = {
    name: "div",
    size: {
        width: 100,
        height: 80
    }
};
console.log(element);
let element_clone = structuredClone(element);
element.size.height = 120;
console.log(element_clone);
// clones circular references
let user = {};
user.me = user;
console.log(user);
console.log(user.me === user);
let user_clone = structuredClone(user);
console.log(user_clone);
console.log(user_clone.me === user_clone);
// */

/*
// object methods (this)
let user = {
    name: "John",
    sayHi: function () {
        console.log("Hello!");
    }
};
user.sayHi();
// method shorthand
user = {
    name: "Henry",
    sayHi() {
        console.log("Hi!");
    }
};
user.sayHi();
// in methods, "this" refers to the object
user.sayHi = function () {
    console.log(`Hi! I'm ${this.name}!`);
};
user.sayHi();
user.changeName = function (newName) {
    this.name = newName;
};
user.changeName("Joe");
user.sayHi();
// "this" is undefined if no object is bound
function unboundFunction() {
    console.log(this);
}
unboundFunction();
// can use functions as methods
function sayHi() {
    console.log(`Hi! I'm ${this.name}!`);
};
user.sayHi = sayHi;
let admin = {
    name: "Dick",
    sayHi
};
user.sayHi();
admin.sayHi();
// arrow functions have no "this"
admin.sayHi = () => {
    // console.log(`Hi! I'm ${this.name}!`);
    console.log(this); // window
}
admin.sayHi();
// function makeUser(userName) {
//     let newUser = {
//         userName
//     }
//     newUser.ref = newUser;
//     return newUser;
// }
// let selfRefUser = makeUser("Barbara");
// console.log(selfRefUser);
// console.log(selfRefUser.ref);
// */

/*
// calculator
const calculator = {
    leftOperand: null,
    rightOperand: null,
    read() {
        this.leftOperand = Number(prompt("left operand", "0"));
        this.rightOperand = Number(prompt("right operand", "0"));
    },
    sum() {
        return this.leftOperand + this.rightOperand;
    },
    mul() {
        return this.leftOperand * this.rightOperand;
    }
}
// calculator.read();
// console.log(`sum: ${calculator.sum()}`);
// console.log(`mul: ${calculator.mul()}`);
// calculator v2
function CalculatorV2() {
    this.leftOperand = null;
    this.rightOperand = null;
    this.read = function () {
        this.leftOperand = Number(prompt("left operand", "0"));
        this.rightOperand = Number(prompt("right operand", "0"));
    };
    this.sum = function () {
        return this.leftOperand + this.rightOperand;
    };
    this.mul = function () {
        return this.leftOperand * this.rightOperand;
    };
}
const calculatorV2 = new CalculatorV2();
// calculatorV2.read();
// console.log(`sum: ${calculatorV2.sum()}`);
// console.log(`mul: ${calculatorV2.mul()}`);
// ladder
let ladder = {
    step: 0,
    up() {
        this.step++;
        return this;
    },
    down() {
        this.step--;
        return this;
    },
    showStep() { // shows the current step
        console.log(this.step);
        return this;
    }
};
// ladder.showStep();
// ladder.up();
// ladder.up();
// ladder.showStep();
// ladder.down();
// ladder.showStep();
// ladder.showStep().up().up().showStep().down().showStep();
// accumulator
function Accumulator(startValue) {
    this.counter = startValue;
    this.read = function () {
        this.counter += Number(prompt("How many to add", "0"));
    };
    this.show = function () {
        console.log(this.counter);
    };
}
const accumulator = new Accumulator(0);
accumulator.read();
accumulator.read();
accumulator.show();
// */

/*
// object constructor
// constructor functions are standard functions
// - first letter capital
// - should only be called with "new"
function User(name) {
    this.name = name;
    this.isAdmin = false;
    // self reference
    this.selfRef = this;
    this.sayHi = function () {
        let message = `Hi! my name is ${this.name}.`;
        if (this.isAdmin) {
            message += " I am an admin.";
        } else {
            message += " I am not an admin.";
        }
        console.log(message);
    }
}
let user = new User("joe");
console.log(user);
console.log(user.name);
console.log(user.isAdmin);
console.log(user.selfRef.selfRef.selfRef.selfRef.name)
user.isAdmin = true;
user.sayHi();
// create an object without storing the constructor
const building = new function () {
    this.height = 3;
    this.material = "bricks";
};
console.log(building);
// */

/*
// symbols
let id1 = Symbol("id");
let id2 = Symbol("id");
console.log(id1 === id2);
console.log(id1.toString());
console.log(id1.description);
// can be used to add keys to objects that doesn't mess with predefined keys
// or keys added in the future
let user = {name: "John"};
user[id1] = 3;
console.log(user[id1]);
// skipped by for in loops
for (let key in user) {
    console.log(key);
}
// */

/*
// object conversion to primitive
// use Symbol.toPrimitive to define a general conversion method
function User() {
    this.name = "John";
    this.money = 1000;
    this[Symbol.toPrimitive] = function (hint) {
        // "hint" can be "string", "number" or "default"
        let result;
        if (hint === "string") {
            result = this.name;
        }
        else {
            result = this.money;
        }
        return result;
    };
}
const user = new User();
console.log(user);
console.log(String(user));
console.log(Number(user));
// can also use toString and valueOf methods
// -> old-school javascript, not recommended
function Car() {
    this.brand = "Porsche";
    this.price = 150000;
    this.toString = function () {
        return this.brand;
    };
    this.valueOf = function () {
        return this.price;
    };
}
const car = new Car();
console.log(car);
console.log(String(car));
console.log(Number(car));
// */

/*
// primitive methods: numbers
let n = 1.23456;
console.log(n.toFixed(2));
// can define numbers with "_" for readability
n = 1_000_000_000;
console.log(n);
// powers of 10
n = 1e9;
console.log(n);
n = 7.3e9;
console.log(n);
n = 1e-6;
console.log(n);
n = -3e4;
console.log(n);
// hexadecimal notation
n = 0xFF;
console.log(n);
n = 0xff;
console.log(n);
// binary notation
n = 0b100000000;
console.log(n);
// octal notation
n = 0o10;
console.log(n);
// convert to a string in the base provided
n = 255;
console.log(n.toString(16));
console.log(n.toString(2));
console.log(123456..toString(36)); // 2 dots to access the method from a litteral
// roundings
console.log(Math.ceil(3.5));
console.log(Math.floor(3.5));
console.log(Math.round(3.5));
// round to the nearest 10th
console.log(Math.round(6.35 * 10) / 10);
console.log(3.66666.toFixed(3)); // returns a string
console.log(3..toFixed(3)); // adds zeros
// upper boundary: Infinity
console.log(1e500);
// solve .1 + .2 === .3: round to the nearest 100th
let sum = .1 + .2;
console.log(Number(sum.toFixed(2)) === .3);
// check if finite or NaN
console.log(isFinite(4));
console.log(isFinite(-Infinity));
console.log(isFinite(NaN)); // NaN is not finite
console.log(isNaN(-3.2));
console.log(isNaN(NaN));
console.log(isNaN("str")); // converted to number
// Number.isFinite and Number.isNaN check for type as well
console.log(Number.isFinite("0"));
console.log(Number.isNaN("str"));
// parse a number from a string
console.log(parseInt("100px"));
console.log(parseFloat("12.5em"));
console.log(parseInt("a150")); // NaN
// parseInt can be used to read a  number from a different base
console.log(parseInt("0xff", 16));
console.log(parseInt("ff", 16));
console.log(parseInt("100000000", 2));
console.log(parseInt("2n9c", 36));
// max and min
console.log(Math.max(1.6, -2.3, 5, 15, 4, -10));
console.log(Math.min(1.6, -2.3, 5, 15, 4, -10));
// */

/*
// randomRange function
function randomRange(lowerBound, upperBound) {
    // Math.random returns a number between 0 included and 1 excluded
    // console.log(Math.random());
    // // between 0 included and 5 excluded
    // console.log(Math.random() * 5);
    // // int between 0 and 4 included
    // console.log(Math.floor(Math.random() * 5));
    return Math.floor(Math.random() * (upperBound - lowerBound + 1)) + lowerBound
}
console.log(randomRange(5, 10));
console.log(randomRange(-5, 0));
console.log((randomRange(3, 3)));
// */

/*
// primitive methods: strings
// new line
console.log("1st line\n2nd line");
console.log("backslash: \\");
console.log("tab\t\ttab");
// number of characters
let str = "abcde";
console.log(str.length);
// access individual characters
console.log(str[0]);
console.log(str[10]); // undefined
console.log(str.charAt(1));
console.log(typeof str.charAt(1));
console.log(str.charAt(15));
console.log(typeof str.charAt(15));
// "at" accepts negative inputs
console.log(str.at(-1));
// strings are immutable
// str[0] = "f"; // error
// change the case
console.log(str.toUpperCase());
str = "ABCDE";
console.log(str.toLowerCase());
// look for a substring
console.log(str.indexOf("BCD"));
console.log(str.indexOf("not there")); // -1
// start searching from index
console.log(str.indexOf("ABC", 2));
str = "as sly as fox, as strong as an ox";
let substringIndex = -1;
while ((substringIndex = str.indexOf("as", substringIndex + 1)) !== -1) {
    console.log(substringIndex);
}
// includes
str = "Widget with id";
console.log(str.includes("id"));
console.log(str.includes("bye"));
// start looking from index
console.log(str.includes("with", 10));
// startsWith, endsWith
console.log(str.startsWith("Widget"));
console.log(str.endsWith("id"));
// get a substring: [start, end[
// slice method
console.log(str.slice(0, 6));
console.log(str.slice(0, 6).length);
console.log(str.slice(12)); // end = Infinity by default
// supports negative indices
console.log(str.slice(-7, -1)); // -> not great
// substring mmethod
console.log(str.substring(7, 11));
console.log(str.substring(11, 7)); // can swap numbers
// substr method (deprecated)
// str.substr(start[, length])
console.log(str.substr(7, 4));
// */

/*
// capitalize function
function capitalize(str) {
    // str is a single word (no white spaces or punctuations)
    // let result = str.toLowerCase();
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}
console.log(capitalize("HAHA"));
console.log(capitalize("b"));
console.log(capitalize(""));
console.log(capitalize("john"));
// */

/*
// arrays
// constructor
let arr;
arr = new Array();
arr = [];
console.log(arr);
console.log(typeof arr); // "object"
// basic definition
let fruits = ["apple", "apricot", "banana"];
console.log(fruits);
// length of array
console.log(fruits.length);
// access elements
console.log(fruits[0]);
console.log(fruits[1]);
console.log(fruits[2]);
console.log(fruits[5]); // undefined
console.log(fruits[-1]); // undefined
// replace and add
fruits[1] = "cherry";
fruits[fruits.length] = "pear";
console.log(fruits);
// can store any types (not recommended)
arr = ["a", 3, true, function () {}, {name: "Robert"}];
console.log(arr);
// "at" supports negative indices
console.log(fruits.at(-1));
// remove from end
let fruit;
fruit = fruits.pop();
console.log(fruit);
console.log(fruits);
// add to end
fruits.push("grape");
console.log(fruits);
// remove from beginning
fruit = fruits.shift();
console.log(fruit);
console.log(fruits);
// add to beginning
fruits.unshift("peach");
console.log(fruits);
// loops
// classic method
for (let index = 0; index < fruits.length; index++) {
    console.log(fruits[index]);
}
// "for of" method
for (fruit of fruits) {
    console.log(fruit);
}
// "for in" loops through all properties (not recommended)
for (let index in fruits) {
    console.log(fruits[index]);
}
// can mess indices up
arr = [];
arr[124] = "haha";
console.log(arr.length); // 125
// can truncate arrays
arr = [1,2,3,4,5];
arr.length = 2;
console.log(arr);
// clear an array
arr.length = 0;
console.log(arr);
// matrices
let mat = [
    [1,2,3],
    [4,5,6],
    [7,8,9]
];
console.log(mat);
console.log(mat[1][1]);
// toString
arr = [1,2,3];
console.log(String(arr)); // "1,2,3"
// make an object from an array
let objArray = [
    ["name", "John"],
    ["age", 30]
];
let userObj = Object.fromEntries(objArray);
console.log(userObj);
// */

/*
// array methods
let arr = [10, 20, 30];
let removed;
console.log(arr);
// Array.splice synthax: arr.splice(startIndex, numberElements, ...newElements)
// remove elements
removed = arr.splice(1, 1); // remove the second element (1 element starting from the second one)
console.log(arr); // [10, 30]
console.log(removed);
// insert elements
removed = arr.splice(1, 0, 20, 21, 22);
console.log(arr); // [10, 20, 21, 22, 30]
console.log(removed);
// remove the first 2 elements and replace them
removed = arr.splice(0, 2, 15, 16);
console.log(arr); // [15, 16, 21, 22, 30]
console.log(removed);
// subarrays
let subArr;
subArr = arr.slice(2, 4);
console.log(subArr); // [21, 22]
subArr = arr.slice(2);
console.log(subArr); // [21, 22, 30]
// concatenations
let concatArr;
concatArr = arr.concat([40, 50]);
console.log(concatArr);
concatArr = arr.concat([40, 50], [60, 70]);
console.log(concatArr);
concatArr = arr.concat([40, 50], 60, 70);
console.log(concatArr);
// iterate through arrays
arr.forEach(function (item, index, array) {
    console.log(`${index}: ${item}`);
    console.log(array); // reference to arr
    // console.log(this); // undefined
});
// search for element
// arr.indexOf returns the index of the element if found
console.log(arr.indexOf(30));
console.log(arr.indexOf(35)); // -1
console.log(arr.indexOf(30, 5)); // not found after index 5
// return the last index of found item
console.log(["apple", "cherry", "apple"].lastIndexOf("apple")); // 2
// arr.includes returns "true" if the element is found
console.log(arr.includes(30));
console.log(arr.includes(35)); // false
console.log(arr.includes(30, 5)); // not found after index 5
// check for NaN only works for "includes"
console.log([NaN].indexOf(NaN)); // -1
console.log([NaN].includes(NaN)); // true
// find an element using a callback
let userArray = [
    {id: 1, name: "John"},
    {id: 2, name: "Fred"},
    {id: 3, name: "Bob"},
    {id: 4, name: "John"}
];
let foundUser = userArray.find(function (item, index, array) {
    return item.id === 2;
});
console.log(foundUser);
console.log(foundUser.name);
// returns "undefined" if the search failed
foundUser = userArray.find(user => user.id === 5);
console.log(foundUser);
// get the index of the item found
let indexUser = userArray.findIndex(user => user.id === 2);
console.log(indexUser); // 1
indexUser = userArray.findIndex(user => user.id === 5);
console.log(indexUser); // -1
// search from the end
indexUser = userArray.findLastIndex(user => user.name === "John");
console.log(indexUser); // 3
// filter the array with a callback
let filteredArray = userArray.filter(function (item, index, array) {
    return item.id > 2;
});
console.log(filteredArray);
// map an array with a callback
let mappedArray = userArray.map(function (item, index, array) {
    return item.name.length;
});
console.log(mappedArray);
// sort with a callback (in place)
// 0 if equal, 1 if greater, -1 if less
let numArr = [1, 6, 2, 6];
// numArr.sort(function (a, b) {
//     let result;
//     if (a > b) result = 1;
//     else if (a === b) result = 0;
//     else result = -1;
//     return result;
// });
numArr.sort(function (a, b) {return a - b;});
console.log(numArr);
// inverse sort
numArr.reverse((a, b) => a - b);
console.log(numArr);
// split a string
let str = "Bilbo, Pippin, Merry";
arr = str.split(", ");
console.log(arr);
// join strings
str = arr.join(";");
console.log(str);
// reduce array (sum, max, min, ...)
numArr = [1,2,3,4,5];
// sum
console.log(numArr.reduce((accumulator, item, index, array) => item + accumulator, 0));
// min
function min(a, b) {
    return a <= b ? a : b;
}
console.log(numArr.reduce(min, numArr[0]));
// max
function max(a, b) {
    return a >= b ? a : b;
}
console.log(numArr.reduce(max, numArr[0]));
// check if object is an array
console.log(Array.isArray({}));
console.log(Array.isArray([]));
// make a real array from an array-like
let arrayLike = {
    0: "haha",
    1: "lol",
    length: 2
};
console.log(Array.isArray(arrayLike));
arr = Array.from(arrayLike);
console.log(Array.isArray(arr));
// */

/*
// calculator
function Calculator() {
    this.operators = {};
    this.calculate = function (formula) {
        let operatorNames = Object.keys(this.operators);
        // console.log(operatorNames);
        // console.log(Array.isArray(operatorNames));
        // console.log(formula);
        let formulaElements = formula.split(" ");
        // console.log(formulaElements);
        // let indexOperator = operatorNames.findIndex(key => key === formulaElements[1]);
        // console.log(indexOperator);
        // if (indexOperator === -1) {
        if (!operatorNames.includes(formulaElements[1])) {
            console.log("operator not implemented");
            return NaN;
        }
        // return this.operators[formulaElements[1]](Number(formulaElements[0]), Number(formulaElements[2]));
        return this.operators[formulaElements[1]](+formulaElements[0], +formulaElements[2]);
    };
    this.addOperator = function (symbol, operation) {
        this.operators[symbol] = operation;
    };
}
const calculator = new Calculator();
calculator.addOperator("+", (a, b) => a + b);
console.log(calculator);
console.log(calculator.calculate("7 + 3"));
console.log(calculator.calculate("7 * 3"));
calculator.addOperator("*", (a, b) => a * b);
console.log(calculator.calculate("7 * 3"));
// */

/*
// iterables
let range = {
    from: 1,
    to: 5
};
// to make "range" an iterator:
range[Symbol.iterator] = function () {
    // returns an object that will be used in the loop
    return {
        current: this.from,
        last: this.to,
        // this object must have a method "next" that will return the value
        next() {
            let result = {
                done: false,
                value: this.current
            };
            if (this.current > this.last) {
                result.done = true;
            }
            else {
                this.current++;
            }
            return result;
        }
    };
};
for (let num of range) {
    console.log(num);
}
// we can make the "range" object the iterator itself
// -> downside: can't make 2 separate iterables
range = {
    from: 1,
    to: 5,
    [Symbol.iterator]() {
        this.current = this.from;
        return this;
    },
    next() {
        let result = {
            done: false,
            value: this.current
        };
        if (this.current > this.to) {
            result.done = true;
        }
        else {
            this.current++;
        }
        return result;
    }
};
for (let num of range) {
    console.log(num);
}
// strings are iterables
for (let char of "abcde") {
    console.log(char);
}
// make an array from an iterable
let numArray = Array.from(range);
console.log(numArray);
console.log(Array.isArray(numArray));
let charArray = Array.from("abcde");
console.log(charArray);
console.log(Array.isArray(charArray));
// */

/*
// make a function that returns a python-style "range" iterable
function range(start, stop, step=1) {
    return {
        start,
        stop,
        step,
        [Symbol.iterator]() {
            this.current = this.start;
            return this;
        },
        next() {
            const nextObject = {
                done: false,
                value: this.current
            };
            if (this.current >= this.stop) {
                nextObject.done = true;
            }
            else {
                this.current += this.step;
            }
            return nextObject;
        }
    };
}
for (let index_line of range(0, 10)) {
    for (let index_column of range(0, 10)) {
        console.log(`${index_line} ${index_column}`);
    }
}
console.log(Array.from(range(0, 5)));
// */

/*
// map type: object that accepts keys of any types
let map = new Map();
console.log(map);
console.log(typeof map);
// add key/value pairs
// map.set(true, "bool");
// map.set("1", "str");
// map.set(1, "num");
// map.set returns the map
map.set(true, "bool").set("1", "str").set(1, "num");
console.log(map);
// get stored values
console.log(map.get(true));
console.log(map.get("1"));
console.log(map.get(1));
// get size
console.log(map.size);
// check if a key exists
console.log(map.has(true));
console.log(map.has(false));
// remove a key/value pair
map.delete(true);
console.log(map);
// clear the map
map.clear();
console.log(map);
// looping over the map
// -> Map preserves entry order
map = new Map([
    ["boys", 3],
    ["girls", 50]
]);
for (let key of map.keys()) {
    console.log(key);
}
for (let value of map.values()) {
    console.log(value);
}
for (let entry of map.entries()) {
    // returns [key, value] arrays
    console.log(entry);
    console.log(Array.isArray(entry));
}
map.forEach(function (value, key, mapRef) {
    console.log(key);
    console.log(value);
    console.log(mapRef); // self reference
});
// make a map from an object
let user = {
    name: "John",
    age: 30
};
console.log(user);
console.log(Object.entries(user));
let userMap = new Map(Object.entries(user));
console.log(userMap);
// make an object from a map
user = Object.fromEntries(userMap.entries());
console.log(user);
// */

/*
// set type: array where every value can appear only once
let set = new Set();
console.log(set);
console.log(typeof set);
// add values
// set.add("apple");
// set.add("banana");
// set.add("orange");
// "add" returns the set itself
set.add("apple").add("banana").add("orange");
// cannot add the same value twice
set.add("apple");
console.log(set);
// get size
console.log(set.size);
// delete values
set.delete("apple");
console.log(set);
// can delete values that don't exist
set.delete("blbl");
// empty the set
set.clear();
console.log(set);
// iterate over a set
set.add("apple").add("banana").add("orange");
for (let item of set) {
    console.log(item);
}
set.forEach(function (value, valueAgain, setRef) {
    console.log(value);
    console.log(valueAgain); // for compatibility with Map
    console.log(setRef);
});
// make a set from an array
console.log(new Set([1,2,3]));
// make a set from an array
console.log(Array.from((new Set([1,2,3])).values()));
// */

/*
// WeakMap -> doesn't prevent garbage collection
let weakmap = new WeakMap();
console.log(weakmap);
// keys must be object
// weakmap.set("John", "ok");
let user = {name: "John"};
weakmap.set(user, "OK");
console.log(weakmap);
console.log(weakmap.get(user));
user = null;
// user will not be accessible from the weakmap, and will be deleted from memory
// useful when we want to add data to an object without modifying it
// the added data will be deleted with the object
// WeakSet works the same but for sets
// */

/*
// store "unread" flags
let messages = [
    {text: "message 1", from: "John"},
    {text: "message 2", from: "Eric"},
    {text: "blbl", from: "Jane"}
];
console.log(messages);
let unreadFlagsMap = new WeakMap();
messages.forEach(function(user) {
    unreadFlagsMap.set(user, true);
});
console.log(unreadFlagsMap);
messages.splice(0, 1);
console.log(messages);
// */

/*
// sum the properties
let animals = {
    giraffe: 30,
    elephant: 50,
    goat: 2
};
function sumAnimals (animalsObj) {
    // console.log(Object.values(animalsObj));
    let sum = 0;
    Object.values(animalsObj).values().forEach(function (numAnimals) {
        // console.log(element);
        sum += numAnimals;
    });
    return sum;
}
console.log(sumAnimals(animals));
// */

/*
// destructuring assignment
// destructuring arrays
let arr = ["John", "Doe"];
let [firstName, lastName] = arr;
console.log(firstName);
console.log(lastName);
[firstName, lastName] = "Jane Smith".split(" ");
console.log(firstName);
console.log(lastName);
// ignore entries
arr = ["Julius", "Ceasar", "Emperor", "Veni, vedi, vici"];
let title;
[firstName, , title] = arr;
console.log(firstName);
console.log(title);
// can be used in a loop
let userObj = {
    name: "John",
    age: 30
};
for (let [key, value] of Object.entries(userObj)) {
    console.log(`${key}: ${value}`);
}
// can get the rest of the array with "..."
let rest;
[firstName, lastName, ...rest] = arr
console.log(firstName);
console.log(lastName);
console.log(rest);
// default values
[firstName = "Guest", lastName = "Anonymous"] = ["Julius"];
console.log(firstName);
console.log(lastName);
// destructuring objects (only works when matching keys, and with "let")
let options = {
    windowTitle: "My window",
    width: 150,
    height: 100
};
console.log(options);
let {windowTitle, width, height} = options;
console.log(windowTitle, width, height);
// can rename keys
let {windowTitle: t, width: w, height: h} = options;
console.log(t, w, h);
// default values
let {windowTitle: wt, missingKey = "lost"} = options;
console.log(wt, missingKey);
// can use parentheses to use previously declared variables
({windowTitle} = options);
console.log(windowTitle);
// can group unsused key/value pairs in a new object with "..."
({windowTitle, ...rest} = options);
// smart function parameters
// destructuring can be used to easily call functions with optional parameters
options = {
    title: "My title",
    items: ["item1", "item2"]
};
function showMenu({
    title = "Untitled",
    width = 200,
    height = 100,
    items = []
} = {}) {
    console.log(`${title}: ${width}x${height}`);
    console.log(items.length);
    items.forEach(function (value) {
        console.log(value);
    })
}
showMenu();
showMenu(options);
// */

/*
// destructuring exercises
// ex 1
let user = {userName: "John", years: 30};
let {userName, years: age, isAdmin = false} = user;
console.log(userName, age, isAdmin);
// ex 2
function topSalary(salariesObj) {
    let result = {
        name: null,
        salary: -Infinity
    };
    for (let [name, salary] of Object.entries(salariesObj)) {
        if (salary > result.salary) {
            result.name = name;
            result.salary = salary;
        }
    }
    return result.name;
}
let salaries = {
    John: 100,
    Henry: 200,
    Jack: 150
};
console.log(topSalary(salaries));
console.log(topSalary({}));
// */

/*
// date and time
let now = new Date();
console.log(now);
// date from milliseconds (timestamp) since epoch
let jan_01_1970 = new Date(0);
console.log(jan_01_1970);
let jan_02_1970 = new Date(24 * 3600 * 1000);
console.log(jan_02_1970);
// get timestamp from date
console.log(jan_01_1970.getTime());
console.log(Number(jan_01_1970));
// negative timestamps
let dec_31_1969 = new Date(-24 * 3600 * 1000);
console.log(dec_31_1969);
// new Date(datestring)
console.log(new Date("03-10-1994"));
// new Date(year, month, date, hours, minutes, seconds, ms)
// months start from 0
console.log(new Date(1990, 0, 10));
// maximal precision is 1ms
let randomDate = new Date(2011, 0, 1, 2, 3, 4, 567);
console.log(randomDate);
// get date components
console.log(
    randomDate.getFullYear(),
    randomDate.getMonth(),
    randomDate.getDate(),
    randomDate.getHours(),
    randomDate.getMinutes(),
    randomDate.getSeconds(),
    randomDate.getMilliseconds()
);
// day of week (0-sunday to 6-saturday)
console.log(randomDate.getDay());
// set date components
randomDate.setFullYear(2008);
randomDate.setMonth(4);
randomDate.setDate(25);
randomDate.setHours(10);
randomDate.setMinutes(30);
randomDate.setSeconds(55);
randomDate.setMilliseconds(321);
console.log(randomDate);
// set date from timestamp
randomDate.setTime(0);
console.log(randomDate);
// dates are autocorrected
console.log(new Date(2013, 0, 32)); // -> becomes feb 1st
// get current timestamp
console.log(Date.now());
// measure time
let start = Date.now();
for (let i = 0; i <= 10000000; i++) {
    let something = i * i * i;
}
let end = Date.now();
console.log(`time spent: ${end - start}ms`);
// */

/*
// benchmarking
function diffSubtract(date1, date2) {
    return date2 - date1;
}
function diffGetTime(date1, date2) {
    return date2.getTime() - date1.getTime();
}
function bench(f) {
    let date1 = new Date(0);
    let date2 = new Date();
    let start = Date.now();
    for (let i = 0; i < 100000; i++) {
        f(date1, date2);
    }
    let end = Date.now();
    return end - start;
}
console.log(`benchmark of diffSubtract: ${bench(diffSubtract)}ms`);
console.log(`benchmark of diffGetTime: ${bench(diffGetTime)}ms`);
// */

/*
// JSON
let student = {
    name: 'John',
    age: 30,
    isAdmin: false,
    courses: ['html', 'css', 'js'],
    spouse: null
};
let studentJSON = JSON.stringify(student);
console.log(typeof studentJSON);
console.log(studentJSON);
// can stringify to JSON many types
console.log(JSON.stringify(true));
console.log(JSON.stringify(null));
console.log(JSON.stringify([1,2,3]));
// replacer function
JSON.stringify(student, function (key, value) {
    console.log(`${key} (${typeof key}): ${value} (${typeof value})`);
    // "this" is the containing object (recursively)
    console.log(`this: ${this}`);
    return value;
});
// "space" is used to output a pretty string (indentation)
console.log(JSON.stringify(student, null, 2));
// implement a method "toJSON" to customize JSON.stringify
let room = {
    number: 23,
    toJSON() {
        return this.number;
    }
};
let meetup = {
    title : "Conference",
    room
};
let meetupJSON = JSON.stringify(meetup, null, 2);
console.log(meetupJSON);
// parse an object from a JSON
console.log(JSON.parse(meetupJSON));
// */

// /*
// recursive function
// direct "pow" with "for" loop
function powDirect(x, n) {
    let result = 1;
    for (let i = 0; i < n; i++) {
        result *= x;
    }
    return result;
}
console.log(powDirect(2, 4));
console.log(powDirect(2, 0));
console.log(powDirect(3, 3));
// recursive "pow"
function powRecursive(x, n) {
    let result;
    if (n == 0) {
        result = 1;
    }
    else if (n == 1) {
        result = x;
    }
    else {
        result = x * powRecursive(x, n - 1);
    }
    return result;
}
console.log(powRecursive(2, 4));
console.log(powRecursive(2, 0));
console.log(powRecursive(3, 3));
// */
