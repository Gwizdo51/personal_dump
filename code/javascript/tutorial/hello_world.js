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
// for(begin; condition; step)
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
console.log(user.name);
console.log(user.isAdmin);
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

// /*
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
