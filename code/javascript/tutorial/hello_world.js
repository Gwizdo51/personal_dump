"use strict";

/* to check:
- jquery
- bootstrap
- vue.js
*/

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
// ?? (nullish coalescing) operator: itself if defined (not "null" nor "undefined"), else provided value
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
// global variable, default parameters
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
    };
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
    title: "Conference",
    room
};
let meetupJSON = JSON.stringify(meetup, null, 2);
console.log(meetupJSON);
// parse an object from a JSON
console.log(JSON.parse(meetupJSON));
// */

/*
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

/*
// linked list
let linkedListTest = {
    value: 0,
    next: {
        value: 1,
        next: {
            value: 2,
            next: null
        }
    }
};
linkedListTest.next.next.next = {value: 3, next: null};
// console.log(linkedListTest);
// 2 classes: LinkedList + LinkedListNode
// function User(name) {
//     this.name = name;
//     this.isAdmin = false;
//     // self reference
//     this.selfRef = this;
//     this.sayHi = function () {
//         let message = `Hi! my name is ${this.name}.`;
//         if (this.isAdmin) {
//             message += " I am an admin.";
//         } else {
//             message += " I am not an admin.";
//         }
//         console.log(message);
//     }
// }
// // let user = new User("joe");
function isRequired(parameterName) {
    throw new Error(`parameter "${parameterName}" is required`);
}
function LinkedListNode(value=isRequired("value"), next=null) {
    this.value = value;
    this.next = next;
}
function LinkedList() {
    this.firstNode = null;
    // methods:
    // - fromArray
    this.fromArray = function (array=[]) {
        // clear the list
        this.clear();
        // console.log(array);
        // make a local copy of the array
        let arrayCopy = Array.from(array)
        // console.log(arrayCopy);
        // console.log(array === array);
        // console.log(array === arrayCopy);
        // add each element from the array to the list
        for (let element of arrayCopy.reverse()) {
            this.appendFirst(element);
        }
        return this;
    };
    // - toArray
    this.toArray = function () {
        let array = [];
        // add each element of the list to the array
        let currentNode = this.firstNode;
        while (currentNode) {
            array.push(currentNode.value);
            currentNode = currentNode.next;
        }
        return array;
    };
    // - getLength
    this.getLength = function () {
        let length = 0;
        let currentNode = this.firstNode;
        while (currentNode) {
            currentNode = currentNode.next;
            length++;
        }
        return length;
    };
    // - appendFirst
    this.appendFirst = function (value) {
        // create a new node with the provided data
        let newNode = new LinkedListNode(value, this.firstNode);
        // add the new node at the start of the list
        this.firstNode = newNode;
        return this;
    };
    // - appendLast
    this.appendLast = function (value) {
        // create a new node with the provided data
        let newNode = new LinkedListNode(value);
        // if the list is empty, set the node as the first node
        if (!this.firstNode) {
            this.firstNode = newNode;
        }
        else {
            // look for the last node of the list
            let lastNode = this.firstNode;
            while (lastNode.next) {
                lastNode = lastNode.next;
            }
            // add the new node at the end of the list
            lastNode.next = newNode;
        }
        return this;
    };
    // - insert
    this.insert = function (value, index=isRequired("index")) {
        // create a new node with the provided data
        let newNode = new LinkedListNode(value);
        // if the index is 0 or the list is empty ...
        if (index === 0 || !this.firstNode) {
            // set the new node as the first node
            newNode.next = this.firstNode;
            this.firstNode = newNode;
        }
        else {
            // look for the node before the one at the given index, or the last node
            let currentNode = this.firstNode;
            let currentIndex = 0;
            while (currentNode.next) {
                if (currentIndex === index - 1) {
                    break;
                }
                currentNode = currentNode.next;
                currentIndex++;
            }
            // insert the new node after the current node
            newNode.next = currentNode.next;
            currentNode.next = newNode;
        }
        return this;
    };
    // - getValue
    this.getValue = function (index=isRequired("index")) {
        let currentNode = this.firstNode;
        let currentIndex = 0;
        let value;
        while (currentNode) {
            if (currentIndex == index) {
                value = currentNode.value;
                break;
            }
            currentNode = currentNode.next;
            currentIndex++;
        }
        return value;
    };
    // - replace
    this.setValue = function (value, index=isRequired("index")) {
        // look for the node at the specified index
        let currentNode = this.firstNode;
        let currentIndex = 0;
        while (currentNode) {
            if (currentIndex === index) {
                currentNode.value = value;
                break;
            }
            currentNode = currentNode.next;
            currentIndex++;
        }
        return this;
    };
    // - copy
    this.copy = function () {
        // create a new empty list
        let listCopy = new LinkedList();
        // copy each element
        let currentNode = this.firstNode;
        while (currentNode) {
            listCopy.appendLast(currentNode.value);
            currentNode = currentNode.next;
        }
        return listCopy;
    };
    // - popFirst
    this.popFirst = function () {
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.firstNode) {
            poppedValue = this.firstNode.value;
            this.firstNode = this.firstNode.next;
        }
        return poppedValue;
    };
    // - popLast
    this.popLast = function () {
        // if the list is empty, don't do anything
        // if the list has a single node, return its value and empty the list
        // if the list has at least 2 nodes, look for the node before the last one,
        // return its value and drop it
        let poppedValue;
        const listLength = this.getLength();
        if (listLength === 1) {
            poppedValue = this.firstNode.value;
            this.firstNode = null;
        }
        else if (listLength > 1) {
            let currentNode = this.firstNode;
            while (currentNode.next.next) {
                currentNode = currentNode.next;
            }
            poppedValue = currentNode.next.value;
            currentNode.next = null;
        }
        return poppedValue;
    };
    // - pop
    // doesn't do anything if the index is out of range
    this.pop = function (index=isRequired("index")) {
        let poppedValue;
        // if the index is not out of range ...
        if (index < this.getLength()) {
            if (index === 0) {
                // pop the first node
                poppedValue = this.firstNode.value;
                this.firstNode = this.firstNode.next;
            }
            else {
                // find the node before the one at the provided index
                let currentNode = this.firstNode;
                let currentIndex = 0;
                while (currentIndex !== index - 1) {
                    currentNode = currentNode.next;
                    currentIndex++;
                }
                // pop the next node
                poppedValue = currentNode.next.value;
                currentNode.next = currentNode.next.next;
            }
        }
        return poppedValue;
    };
    // - clear
    this.clear = function () {
        this.firstNode = null;
        return this;
    };
    // conversion to primitive
    this[Symbol.toPrimitive] = function (hint) {
        // console.log(hint);
        // "hint" can be "string", "number" or "default"
        let result;
        // if (hint === "string" || hint === "default") {
        if (hint === "number") {
            result = NaN;
        }
        else {
            // starts with a "["
            result = "[";
            let isFirstElement = true;
            let currentNode = this.firstNode;
            while (currentNode) {
                if (isFirstElement) {
                    result += `${currentNode.value}`;
                    isFirstElement = false;
                }
                else {
                    result += `, ${currentNode.value}`;
                }
                currentNode = currentNode.next;
            }
            // ends with a "]"
            result += "]";
        }
        return result;
    };
}
let linkedList = new LinkedList();
console.log(String(linkedList));
// getLength
console.log(linkedList.getLength());
// appendFirst
linkedList.appendFirst(2);
linkedList.appendFirst(1);
linkedList.appendFirst(0);
linkedList.appendFirst(null);
console.log(String(linkedList));
console.log(linkedList.getLength());
// linkedList.appendFirst(); // error raised
// getValue
console.log(linkedList.getValue(0));
console.log(linkedList.getValue(1));
console.log(linkedList.getValue(2));
console.log(linkedList.getValue(3));
console.log(linkedList.getValue(10)); // undefined
// appendLast, clear
// linkedList = new LinkedList();
linkedList.clear();
linkedList.appendLast(3);
linkedList.appendLast(4);
linkedList.appendLast(5);
linkedList.appendFirst(2).appendFirst(1);
console.log(String(linkedList));
console.log(linkedList.getLength());
// insert
linkedList.insert(4.5, 4);
linkedList.insert(2.5, 2);
linkedList.insert(10, 18);
linkedList.insert(-5, 0);
console.log(String(linkedList));
console.log(linkedList.getLength());
// fromArray
linkedList = new LinkedList();
linkedList.fromArray([1,2,3]);
console.log(String(linkedList));
// toArray
let array = linkedList.toArray();
console.log(array);
// setValue
linkedList.setValue("a", 6);
linkedList.setValue("b", 2);
linkedList.setValue("c", 0);
console.log(String(linkedList));
// copy
let linkedListCopy = linkedList.copy();
console.log(String(linkedListCopy));
// popLast
console.log(linkedList.popLast());
console.log(String(linkedList));
console.log(linkedList.getLength());
console.log(linkedList.popLast());
console.log(linkedList.popLast());
console.log(linkedList.popLast());
// popFirst
linkedList.fromArray([1,2,3]);
console.log(String(linkedList));
console.log(linkedList.popFirst());
console.log(linkedList.popFirst());
console.log(linkedList.popFirst());
console.log(linkedList.popFirst());
// pop
linkedList.fromArray([1,2,3,4,5]);
console.log(linkedList.pop(2));
console.log(linkedList.pop(0));
console.log(linkedList.pop(6));
console.log(linkedList.pop(1));
// to primitive
console.log(linkedList);
console.log(String(linkedList));
console.log(Number(linkedList));
// */

/*
// rest parameters
function sumWrong(a, b) {
    return a + b;
}
console.log(sumWrong(1,2,3,4,5)); // no errors because of excessive args
// can get rest of args with "..." (must be at the end)
function sumRight(...args) {
    let sum = 0;
    for (let arg of args) {
        sum += arg;
    }
    return sum;
}
console.log(sumRight(1,2,3,4,5));
function showName(firstName, lastName, ...titles) {
    let resultString = `${firstName} ${lastName}, `;
    let firstTitle = true;
    for (let title of titles) {
        if (firstTitle) {
            resultString += title;
            firstTitle = false;
        }
        else {
            resultString += `, ${title}`;
        }
    }
    return resultString + ".";
}
console.log(showName("Julius", "Caesar", "Consul", "Imperator", "Human", "Male"));
// functions have a special variable "arguments" that contains every parameters passed to the function
function showArgs() {
    console.log(arguments.length);
    return arguments;
}
console.log(showArgs(1, 2, 3, "a", "b"));
// "unpack"/"spread" an array as the parameters of a function
let argsArray = [1,2,3,4,5];
console.log(Math.max(...argsArray));
// can use multiple arrays
let argsArray2 = [6,7,8,9,10];
console.log(Math.max(...argsArray, ...argsArray2));
// can be used with other values
console.log(Math.max(...argsArray, ...argsArray2, 15))
// syntax can be used to merge arrays
let mergedArray = [...argsArray, 5.5, ...argsArray2, 11];
console.log(mergedArray);
// works on any iterable
let myName = "Arthur";
console.log([...myName]);
// can be used to make a copy of an array
let argsArrayCopy = [...argsArray];
console.log(JSON.stringify(argsArray) === JSON.stringify(argsArrayCopy)); // same content
console.log(argsArray === argsArrayCopy); // different arrays
// also a copy of an object
let myObj = {
    a: 1,
    b: 2,
    c: 3
};
let myObjCopy = {...myObj};
console.log(JSON.stringify(myObj) === JSON.stringify(myObjCopy)); // same content
console.log(myObj === myObjCopy); // different obj
// */

/*
// variable scope
// code blocks can declare local variables
{
    let myVar = "Hello";
    console.log(myVar);
}
// console.log(myVar); // error: myVar is not defined
// can redefine variables locally
let message = "Hello";
console.log(message);
{
    let message = "Goodbye";
    console.log(message);
}
console.log(message);
// also true for if, else, for and while blocks
if (true) {
    let phrase = "I exist.";
    console.log(phrase);
}
// console.log(phrase); // error: phrase is not defined
// nested functions
function sayHiBye(firstName, lastName) {
    function getName() {
        return `${firstName} ${lastName}`;
    }
    console.log(`Hi, ${getName()}!`);
    console.log(`Bye, ${getName()}.`);
}
sayHiBye("Arthur", "Clement");
// nested functions can be returned, and will always have access to the same outer variables
function makeCounter() {
    let count = 0;
    return function () {
        count++;
        return count;

    };
}
let counter1 = makeCounter();
let counter2 = makeCounter();
console.log(counter1());
console.log(counter1());
console.log(counter1());
console.log(counter2());
console.log(counter2());
console.log(counter1());
console.log(counter2());
function randomNumber() {
    let value = Math.random();
    return function() { return value; };
}
let function1 = randomNumber();
let function2 = randomNumber();
console.log(function1(), function2());
// */

/*
let personName = "John";
function sayHi() {
    return `Hi ${personName}!`;
}
personName = "Hilbert";
console.log(sayHi());
// make filter functions for arr.filter(f)
// let filteredArray = userArray.filter(function (item, index, array) {
//     return item.id > 2;
// });
// inBetween needs to return a function
function inBetween(a, b) {
    return function (item, index, array) {
        return item >= a && item <= b;
    };
}
function inArray(arr) {
    return function (item, index, array) {
        return arr.includes(item);
    };
}
let array = [1,2,3,4,5,6,7];
console.log(array.filter(inBetween(3,6)));
console.log(array.filter(inArray([1,2,10])));
// sort user by name or by age
let users = [
    {name: "John", age: 30, job: "bouncer"},
    {name: "Bob", age: 72, job: "pimp"},
    {name: "Phil", age: 12, job: "stripteaser"}
];
// 0 if equal, 1 if greater, -1 if less
// let numArr = [1, 6, 2, 6];
// numArr.sort(function (a, b) {
//     let result;
//     if (a > b) result = 1;
//     else if (a === b) result = 0;
//     else result = -1;
//     return result;
// });
function byField(field) {
    return function (a, b) {
        return a[field] > b[field] ? 1 : -1;
    };
}
// console.log(users.sort(byField("name")));
console.log(users.sort(byField("age")));
// */

/*
// global object
console.log(globalThis);
console.log(window === globalThis);
// can be used to make an object available globally
globalThis.currentUser = {name: "John"};
console.log(currentUser.name, globalThis.currentUser.name);
// */

/* function objects
// function name
function sayHi(name) {
    console.log(`Hi ${name}!`);
}
sayHi("Henri");
console.log(sayHi.name);
let sayHi2 = function (name) {
    console.log(`Hi ${name}!`);
};
sayHi2("John");
console.log(sayHi2.name);
// works as default value
function fTest(sayHi = (function () {})) {
    console.log(sayHi.name);
}
fTest();
// it may be impossible to figure out the name
let fArr = [function () {}];
console.log(fArr[0].name === "");
// function length: minimum snumber of parameters
function f1(a) {}
function f2(a, b) {}
function fMany(a, b, ...args) {}
console.log(f1.length);
console.log(f2.length);
console.log(fMany.length);
// can add properties to functions
function sayHiWithCounter() {
    sayHiWithCounter.counter++;
    return "Hi";
}
sayHiWithCounter.counter = 0;
console.log(sayHiWithCounter());
console.log(sayHiWithCounter());
console.log(sayHiWithCounter.counter);
// we can rewrite the counter function with a function property
// only difference here is the counter itself is accessible
function makeCounter() {
    function counter() {
        counter.count++;
        return counter.count;
    }
    counter.count = 0;
    return counter;
}
let counter1 = makeCounter();
let counter2 = makeCounter();
console.log(counter1());
console.log(counter1());
console.log(counter2());
console.log(counter1());
// we can access and change the count
console.log(counter1.count);
counter1.count = 10;
console.log(counter1());
// we can add a name to a function expression so that it can call itself
let sayHi3 = function func(name) {
    let result;
    if (name) {
        result = `Hi, ${name}!`;
    }
    else {
        result = func("Guest");
    }
    return result;
};
console.log(sayHi3());
// console.log(func()); // error: "func" is undefined
// */

/*
// better makeCounter
function makeCounter() {
    function counter() {
        counter.count++;
        return counter.count;
    }
    counter.count = 0;
    counter.set = function (newCount) {
        counter.count = newCount;
    };
    counter.decrease = function() {
        counter.count--;
    };
    return counter;
}
let counter = makeCounter();
console.log(counter());
counter.set(10);
console.log(counter());
counter.decrease();
counter.decrease();
console.log(counter());
// */

/*
// "new Function": create a function from a string
let sum = new Function("a", "b", "return a+b;");
console.log(sum(1, 2));
// */

/*
// scheduling function calls
// run only once
function sayHi() {
    console.log("Hello!");
}
let timerId = setTimeout(sayHi, 1000);
// cancel scheduled function
clearTimeout(timerId);
// run at interval
function makeCounter() {
    function counter() {
        counter.count++;
        // return counter.count;
        console.log(`call #${counter.count}`);
    }
    counter.count = 0;
    return counter;
}
// timerId = setInterval(makeCounter(), 1000);
// setTimeout(() => clearInterval(timerId), 5000);
// nested setTimeout to run regularly
function tick() {
    tick.counter++;
    console.log(`tick #${tick.counter}`);
    timerId = setTimeout(tick, 1000);
}
tick.counter = 0;
// timerId = setTimeout(tick, 1000);
// setTimeout(() => clearInterval(timerId), 5000);
// any setTimeout call starts at the end of the current script
// zero delay timeout calls the function at the end of the current script
function zeroDelay() {
    setTimeout(() => console.log("world!"));
    console.log("hello");
}
// zeroDelay();
// */

/*
// function that outputs a number every second
function printNumbersInterval(from, to) {
    // let startTime = Date.now();
    let current = from;
    let timerId = setInterval(() => {
        console.log(current);
        if (current === to) {
            clearInterval(timerId);
        }
        current++;
    }, 1000);
    // return timerId;
}
// printNumbersInterval(-2, 6);
function printNumbersTimeout(from, to) {
    let current = from;
    function f() {
        console.log(current);
        current++;
        if (current <= to) {
            // timerId = setTimeout(f, 1000);
            setTimeout(f, 1000);
        }
    }
    // let timerId = setTimeout(f, 1000);
    f();
}
printNumbersTimeout(-5, 1);
// */

/*
// function decorator: return a wrapper around a function
function cachingDecorator(func) {
    let cache = new Map();
    return function (x) {
        let result;
        if (cache.has(x)) {
            result = cache.get(x);
        }
        else {
            result = func(x);
            cache.set(x, result);
        }
        return result;
    };
}
function slow(x) {
    for (let i=0; i<1000000000; i++)  {
        let smth = i*i*i;
    }
    return x;
}
let slowCached = cachingDecorator(slow);
// console.log(slow(5));
// console.log(slow(5));
// console.log(slowCached(5));
// console.log(slowCached(5));
// console.log(slowCached(5));
// console.log(slowCached(8));
// console.log(slowCached(8));
// console.log(slowCached(5));
// console.log(slowCached(8));
// explicitly setting "this" for function context
function sayHi() {
    return `Hi, ${this.name}!`;
}
let user = {
    name: "Henry"
};
let admin = {
    name: "Bob"
};
// console.log(sayHi()); // error: this is undefined
console.log(sayHi.call(user));
console.log(sayHi.call(admin));
// we can use this to decorate object methods
let worker = {
    someMethod() {
        return 1;
    },
    slow(x) {
        for (let i=0; i<3000000000; i++)  {
            let smth = i*i*i * this.someMethod();
        }
        return x;
    }
};
function cachingDecoratorContext(func) {
    let cache = new Map();
    return function (x) {
        let result;
        if (cache.has(x)) {
            result = cache.get(x);
        }
        else {
            result = func.call(this, x);
            cache.set(x, result);
        }
        return result;
    };
}
worker.slowCached = cachingDecoratorContext(worker.slow);
// console.log(worker.slow(10));
// console.log(worker.slow(10));
// console.log(worker.slowCached(10));
// console.log(worker.slowCached(10));
// console.log(worker.slowCached(-5));
// console.log(worker.slowCached(10));
// console.log(worker.slowCached(-5));
// console.log(worker.slowCached(10));
// we can decorate functions with an unknown number of arguments
function slow2(x, y) {
    for (let i=0; i<3000000000; i++)  {
        let smth = i*i*i;
    }
    return x + y;
}
function hash(args) {
    return `${args[0]},${args[1]}`;
}
function cachingDecoratorMultipleArgs(func) {
    let cache = new Map();
    return function () {
        let result;
        let key = hash(arguments);
        if (cache.has(key)) {
            result = cache.get(key);
        }
        else {
            // result = func.call(this, ...arguments);
            result = func.apply(this, arguments);
            cache.set(key, result);
        }
        return result;
    };
}
let slow2Cached = cachingDecoratorMultipleArgs(slow2);
console.log(slow2(1, 2));
console.log(slow2(1, 2));
console.log(slow2Cached(1, 2));
console.log(slow2Cached(1, 2));
console.log(slow2Cached(4, 6));
console.log(slow2Cached(1, 2));
console.log(slow2Cached(4, 6));
console.log(slow2Cached(1, 2));
// */

/*
// spy decorator
function work(x, y) {
    // return arguments;
    return x + y;
}
// console.log(work(1,2));
function spy(func) {
    function wrappedFunc(...args) {
        wrappedFunc.calls.push(args);
        // let result = func.apply(this, args);
        // return result;
        return func.apply(this, args);
    }
    wrappedFunc.calls = [];
    return wrappedFunc;
}
let workSpy = spy(work);
// console.log(workSpy(1, 2));
// console.log(workSpy(1, 2));
// console.log(workSpy(4, 5));
// console.log(workSpy.calls);
// throttling function calls
function f(a) {
    console.log(a);
}
function throttle(func, ms) {
    let cooldown;
}
let f1000 = throttle(f, 1000);
// */

/*
// bind a function to its context
let user = {
    name: "John",
    sayHi() {
        console.log(`Hello, ${this.name}!`);
    }
};
// setTimeout(user.sayHi, 1000); // "this" is lost
// solution #1: a wrapper
// setTimeout(() => user.sayHi(), 1000);
// but if "user" changes during the timeout, "sayHi" will be called on the wrong object
// solution #2: bind "this" to the method
user.sayHi = user.sayHi.bind(user);
// setTimeout(user.sayHi, 1000)
// modifying the "user" variable doesn't change the call
// user = null;
// works with regular arguments
user.say = function (word) {
    console.log(`${word}, ${this.name}!`);
}
let say = user.say.bind(user);
say("Hello");
say("Goodbye");
// we can use "bind" to fix arguments too
function mul(a, b) {
    return a * b;
}
let double = mul.bind(null, 2);
console.log(double(2));
// */

/* object properties flag and descriptors
// 3 flags:
// - writable -> its value can change
// - enumerable -> is listed in loops
// - configurable -> flags can be set and property can be deleted
// get the flags of a property
let user = {
    name: "John"
};
console.log(Object.getOwnPropertyDescriptor(user, "name"));
// change the flags of a property
Object.defineProperty(user, "name", {
    value: "Henry",
    writable: false
});
console.log(Object.getOwnPropertyDescriptor(user, "name"));
// non-writable: any attempt to modify will throw an error
// user.name = "Jack";
// non-enumerable: doesn't show up when looping through properties (also exculded from Object.keys)
user.toString = function () {
    return this.name;
}
// console.log(String(user));
console.log("before setting enumerable to false");
for (let key in user) {
    console.log(key);
}
Object.defineProperty(user, "toString", {
    enumerable: false
});
console.log("after setting enumerable to false");
for (let key in user) {
    console.log(key);
}
// non-configurable: can't change flags, can't delete the property
Object.defineProperty(user, "name", {
    writable: true,
    configurable: false
});
// delete user.name; // error
// Object.defineProperty(user, "name", {
//     configurable: true
// }); // error
// can still change the value
user.name = "Bob";
console.log(String(user));
// set many properties flags at once
user = {
    name: "John",
    age: 36
}
Object.defineProperties(user, {
    name: {value: "Bob", writable: false, configurable: false},
    age: {writeable: false, configurable: false}
});
console.log(user);
// get all property descriptors
console.log(Object.getOwnPropertyDescriptors(user));
// can be used to make a better copy of an object
let userCopy = Object.defineProperties({}, Object.getOwnPropertyDescriptors(user));
console.log(Object.getOwnPropertyDescriptors(userCopy));
// */

/* getters and setters
// 2 types of properties:
// data properties (usual ones)
// accessor properties
user = {
    firstName: "John",
    lastName: "Wayne",
    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    },
    set fullName(value) {
        [this.firstName, this.lastName] = value.split(" ");
    }
};
console.log(user.fullName);
user.fullName = "Bob Harris";
console.log(user);
console.log(user.fullName);
Object.defineProperty(user, 'intials', {
    get() {
        return this.firstName[0] + this.lastName[0];
    },
    // set(value) {

    // },
    enumerable: true
});
console.log(user.intials);
// */

/* prototypal inheritance
console.log("--- set prototype");
let animal = {
    eats: true
};
let rabbit = {
    jumps: true
};
rabbit.__proto__ = animal; // "rabbit" extends "animal" / "animal" is the prototype of "rabbit"
console.log(rabbit);
console.log("--- can inherit methods");
animal.walk = function () {
    console.log("is walking");
};
rabbit.walk();
console.log("--- inheritance is recursive");
let longEar = {
    earLength: 10,
    __proto__: rabbit
};
console.log(longEar.jumps);
longEar.walk();
console.log("--- the prototype is only used for reading, writing/deleting applies to the child object");
animal = {
    walkingMethod: "mixed"
};
let human = {
    __proto__: animal
};
console.log(animal.walkingMethod);
console.log(human.walkingMethod);
human.walkingMethod = "bipedal";
console.log(animal.walkingMethod);
console.log(human.walkingMethod);
console.log("--- methods are applied to the child object");
let user = {
    firstName: "John",
    lastName: "Smith",
    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    },
    set fullName(value) {
        [this.firstName, this.lastName] = value.split(" ");
    }
};
let admin = {
    isAdmin: true,
    __proto__: user
};
admin.fullName = "Alice Cooper";
console.log(user.fullName);
console.log(admin.fullName);
console.log('--- "this" is always the object before the dot');
// here, "animal" is a method storage, and "rabbit" applies them
animal = {
    walk() {
        if (!this.isSleeping) {
            console.log("I walk");
        }
    },
    sleep() {
        this.isSleeping = true;
    }
};
rabbit = {
    name: "Roger",
    __proto__: animal
};
rabbit.walk();
rabbit.sleep();
console.log(rabbit.isSleeping); // true
console.log(animal.isSleeping); // undefined
console.log('--- "for...in" loops loop through inherited properties as well');
animal = {
    eats: true
};
rabbit = {
    jumps: true,
    __proto__: animal
};
for (let prop in rabbit) {
    console.log(prop);
}
console.log('--- obj.hasOwnProperty(key) returns wether a property is inherited');
for (let prop in rabbit) {
    if (rabbit.hasOwnProperty(prop)) {
        console.log(`own: ${prop}`);
    }
    else {
        console.log(`inherited: ${prop}`);
    }
}
// */

/* prototype exercises
let head = {
    glasses: 1
};
let table = {
    pen: 3
};
let bed = {
    sheet: 1,
    pillow: 2
};
let pockets = {
    money: 2000
};
pockets.__proto__ = bed;
bed.__proto__ = table;
table.__proto__ = head;
console.log(pockets.pen, bed.glasses);
// */

/* F.prototype
console.log('--- we can use constructor functions "prototype" property to set the prototype of created objects');
let animal = {
    eats: true
};
function Rabbit(name) {
    this.name = name;
}
Rabbit.prototype = animal;
let myRabbit = new Rabbit("White rabbit");
console.log(myRabbit.eats);
console.log('--- default F.prototype: object with a "constructor" property that references F');
function F() {}
console.log(F.prototype);
console.log(F.prototype.constructor === F);
console.log('--- all objects created with "new F()" have access to the constructor through the prototype');
let obj = new F();
console.log(obj.constructor === F);
// */

/* native prototypes
console.log('--- standard objects all have a default prototype, accessible through their constructor function (new Object())');
let obj = {};
console.log(obj.constructor === Object);
console.log(obj.__proto__ === Object.prototype);
console.log(obj.__proto__);
console.log('--- the "toString" default method is taken from the prototype');
console.log(obj.toString === obj.__proto__.toString);
console.log('--- no more prototypes above Object.prototype');
console.log(Object.prototype.__proto__);
console.log('--- every object inherit from Object.prototype');
let arr = [1, 2, 3];
console.log(arr.__proto__ === Array.prototype);
console.log(arr.__proto__.__proto__ === Object.prototype);
console.log(arr.__proto__.__proto__.__proto__ === null);
console.log('--- prototypes may overwrite methods');
console.log(arr.toString());
console.log('--- we can add methods to native prototypes, and they become available for all objects of this type');
String.prototype.show = function () {
    console.log(this);
};
"LOL".show();
console.log(String.prototype);
// */

// /* native prototypes exercises
Function.prototype.defer = function (timeout) {
    setTimeout(this, timeout);
};
function f() {
    console.log("it works");
}
// f.defer(5000);
// function cachingDecoratorMultipleArgs(func) {
//     let cache = new Map();
//     return function () {
//         let result;
//         let key = hash(arguments);
//         if (cache.has(key)) {
//             result = cache.get(key);
//         }
//         else {
//             // result = func.call(this, ...arguments);
//             result = func.apply(this, arguments);
//             cache.set(key, result);
//         }
//         return result;
//     };
// }
// let slow2Cached = cachingDecoratorMultipleArgs(slow2);
Function.prototype.deferDecorator = function (timeout) {
    let savedThis = this;
    return function () {
        setTimeout(() => savedThis.apply(this, arguments), timeout);
    };
};
function f2(a, b) {
    console.log(a + b);
}
f2.deferDecorator(1000)(1, 2);
// */
