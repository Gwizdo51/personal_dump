"use strict";

// logging helper function
function log(text) {
    console.log(`-- ${text}`);
}

/* browser environment
log('the "window" global object provides methods to control the browser window');
log('global functions are methods of the "window" object');
function sayHi() {
    console.log("Hi!");
}
window.sayHi();
log('the "DOM" represents all page content as modifiable objects');
// change background to red, then back to original color
// document.body.style.background = "red";
// setTimeout(() => {
//     document.body.style.background = "cornflowerblue";
// }, 1000);
// */

/* walking the DOM
log('<html> = document.documentElement');
console.log(document.documentElement);
log('<head> = document.head');
console.log(document.head);
log('<body> = document.body');
console.log(document.body);
log('get childs of a node');
console.log(document.body.childNodes);
log('get first/last child of a node');
console.log(document.body.firstChild);
console.log(document.body.lastChild);
log('get the parent of a node');
console.log(document.body.parentNode);
log('get the siblings of a node');
console.log(document.head.nextSibling);
console.log(document.body.previousSibling);
log('element != node');
log('get child elements of a node');
console.log(document.documentElement.children);
log('get first/last child element of a node');
console.log(document.documentElement.firstElementChild);
console.log(document.documentElement.lastElementChild);
log('get the parent element of a node');
console.log(document.body.parentElement);
log('get the siblings of a node');
console.log(document.head.nextElementSibling);
console.log(document.body.previousElementSibling);
// */

/* searching the DOM
log('get any element of the DOM by ID with "getElementById"');
const pElem = document.getElementById("myPElement");
console.log(pElem);
log('... or directly with its ID (bad idea)');
console.log(myPElement);
myPElement.style.color = "white";
log('get all elements matching the CSS selector with "querySelectorAll"');
console.log(document.querySelectorAll("p"));
// document.querySelectorAll("p").forEach((value) => {
//    value.remove();
// });
log('get the first element matching the CSS selector with "querySelector"');
console.log(document.querySelector("#myPElement"));
log('check whether an element matches a given CSS selector');
console.log(document.querySelector("#myPElement").matches("p"));
log('get the closest ancestor that matches the given CSS selector');
let chapter = document.querySelector(".chapter");
console.log(chapter.closest(".book"));
console.log(chapter.closest(".contents"));
// */

/* node properties
log('display all the properties of an object');
console.dir(document.body);
log('get the tag name of an element');
console.log(document.body.tagName);
log('get/set the HTML content of an element');
console.log(document.body.innerHTML);
// document.body.innerHTML = "<b>prout</b>";
log('get/set the full HTML of an element (inner HTML + itself)');
console.log(document.body.outerHTML);
log('writing to outerHTML replaces it in the DOM, but not in the variable used');
let greeting = document.querySelector("#myPElement");
greeting.outerHTML = "<h1>Hello world!</h1>";
console.log(greeting);
log('get/set all text inside an element');
console.log(document.body.textContent);
log('writing to "textContent" does not process HTML');
const myName = "<b>Robin Hood</b>";
document.querySelector("#nameParagraph1").innerHTML = myName;
document.querySelector("#nameParagraph2").textContent = myName;
log('the "hidden" property can be used to hide an element from the page');
// blinking element
const blinkingDiv = document.querySelector("#blinking");
setInterval(() => {blinkingDiv.hidden = !blinkingDiv.hidden}, 1000);
log('get non-standard attributes and their associated values');
console.log(document.body.id); // myBody
console.log(document.body.truc); // undefined
console.log(document.body.hasAttribute("truc"));
console.log(document.body.getAttribute("truc"));
document.body.setAttribute("truc", "bidule");
console.log(document.body.attributes);
document.body.removeAttribute("truc");
log('all attributes that start with "data-*" are reserved for programmers use, and are available in the "dataset" property of the element');
let myDiv = document.querySelector("div.contents");
console.log(myDiv.dataset);
console.log(myDiv.dataset.about);
console.log(myDiv.dataset.orderState); // kebab-case becomes camelCase
// */

/* modifying the document
log('create an element, with an class and inner HTML');
let divMessage = document.createElement("div");
divMessage.className = "alert";
divMessage.innerHTML = "<strong>Hi there!</strong> You've read an important message.";
console.log(divMessage);
log('add the element at the end of the body');
document.body.append(divMessage);
// node.append -> inserts at the end of "node"
// node.prepend -> inserts at the beginning of "node"
// node.before -> inserts before "node"
// node.after -> inserts after "node"
// node.replaceWith -> replaces "node"
log('add arbitrary HTML to the page');
document.body.insertAdjacentHTML(
    "beforeend",
    "<strong>Hello again!</strong> You've read another important message."
);
// "beforebegin" -> inserts HTML immediatly before "elem"
// "afterbegin" -> inserts HTML into "elem", at the beginning
// "beforeend" -> inserts HTML into "elem", at the end
// "afterend" -> inserts HTML immediatly after "elem"
log('remove elements from the HTML');
setTimeout(() => {document.querySelector("div.alert").remove();}, 1000);
log('move stuff around');
// move the greeting at the end of the page
document.body.append(document.querySelector("#myPElement"));
log('clone an node');
// element.cloneNode(true) -> deep clone
// element.cloneNode(false) -> no child elements
let greetingBye = document.querySelector("#myPElement").cloneNode(true);
greetingBye.textContent = "Bye world!";
document.body.append(greetingBye);
// */

// /* style and classes
log('modify the entire class string of an element');
document.body.className = "main body";
console.log(document.body.className);
log('modify classes 1 by 1');
console.log(document.body.classList);
// add -> adds a class
// remove -> removes a class
// toggle -> adds a class if it's not there, removes it otherwise
// contains -> returns "true" or "false" whether the element is of the given class
document.body.classList.toggle("main");
document.body.classList.toggle("thing");
for (let className of document.body.classList) {
    console.log(className);
}
log('modify the style of an element');
// put all text in white
document.body.style.color = "white";
log('reset the style property');
// hide body
document.body.style.display = "none";
// show it again
setTimeout(() => {document.body.style.display = "";}, 1000);
log('get the computed style of an element');
console.log(getComputedStyle(document.body).backgroundColor);
// */
