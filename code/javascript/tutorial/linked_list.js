"use strict";

// /*
function isRequired(parameterName) {
    throw new Error(`parameter "${parameterName}" is required`);
}

// rewrite the linked list code as a class
class DLinkedListNode {

    // protect the "value", "next" and "previous" properties
    #value;
    #next;
    #previous;

    constructor(value=isRequired('value'), previous=null, next=null) {
        this.value = value;
        this.next = next;
        this.previous = previous;
    }

    // now this class is completely inaccessible from the outside, but still
    get [Symbol.toStringTag]() {
        return this.constructor.name;
    }

    static get [Symbol.species]() {
        return this;
    }

    get value() {
        return this.#value;
    }

    set value(value) {
        // "value" cannot be "undefined"
        if (typeof value === "undefined") {
            throw new Error('the value of a node cannot be "undefined"');
        }
        this.#value = value;
    }

    get next() {
        return this.#next;
    }

    set next(next) {
        // "next" must either be "null" or an instance of "DLinkedListNode"
        if (next !== null && !(next instanceof this.constructor)) {
            throw new Error(`"next" must be either "null" or an instance of "${this.constructor.name}"`);
        }
        this.#next = next;
    }

    get previous() {
        return this.#previous;
    }

    set previous(previous) {
        // "previous" must either be "null" or an instance of "DLinkedListNode"
        if (previous !== null && !(previous instanceof this.constructor)) {
            throw new Error(`"previous" must be either "null" or an instance of "${this.constructor.name}"`);
        }
        this.#previous = previous;
    }
}

class DLinkedList {

    // protect "firstNode" property and set to null on instance creation
    #firstNode = null;
    #lastNode = null;

    constructor(...args) {
        // this.firstNode = null;
        // concat each item of args to "this" -> can't work: infinite loop, concat returns a new linked list
        for (let value of args) {
            this.appendLast(value);
        }
    }

    // [Symbol.toStringTag] = "DLinkedList";
    get [Symbol.toStringTag]() {
        return this.constructor.name;
    }

    // to be able to use obj.constructor[Symbol.species] in the methods that return a new instance ("copy", "filter", "map", "concat", "slice")
    static get [Symbol.species]() {
        return this;
    }

    get firstNode() {
        return this.#firstNode;
    }

    set firstNode(firstNode) {
        // "firstNode" must either be "null" or an instance of "DLinkedListNode"
        if (firstNode !== null && !(firstNode instanceof DLinkedListNode)) {
            throw new Error(`"firstNode" must be either "null" or an instance of "${DLinkedListNode}"`);
        }
        this.#firstNode = firstNode;
    }

    get lastNode() {
        return this.#lastNode;
    }

    set lastNode(lastNode) {
        // "lastNode" must either be "null" or an instance of "DLinkedListNode"
        if (lastNode !== null && !(lastNode instanceof DLinkedListNode)) {
            throw new Error(`"lastNode" must be either "null" or an instance of "${DLinkedListNode}"`);
        }
        this.#lastNode = lastNode;
    }

    // can be done with "concat"
    // static fromArray(array=isRequired()) {}

    [Symbol.toPrimitive] = (hint) => {
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

    get length() {
        let length = 0;
        let currentNode = this.firstNode;
        while (currentNode) {
            length++;
            currentNode = currentNode.next;
        }
        return length;
    }

    // testIsInstance() {
    //     console.log(this instanceof this.constructor);
    // }

    appendFirst = (value) => {
        // create a new node with the provided data
        const newNode = new DLinkedListNode(value);
        // if the list is empty, set the new node as the first and last node
        if (!this.firstNode) {
            this.firstNode = newNode;
            this.lastNode = newNode;
        }
        else {
            // set the first node previous node to the new node
            this.firstNode.previous = newNode;
            // set the new node next node to the original first node
            newNode.next = this.firstNode;
            // set the first node as the new node
            this.firstNode = newNode;
        }
        return this;
    };

    // appendLast = (value) => {
    //     // create a new node with the provided data
    //     const newNode = new DLinkedListNode(value);
    //     // if the list is empty, set the node as the first node
    //     if (!this.firstNode) {
    //         this.firstNode = newNode;
    //     }
    //     else {
    //         // look for the last node of the list
    //         let lastNode = this.firstNode;
    //         while (lastNode.next) {
    //             lastNode = lastNode.next;
    //         }
    //         // add the new node at the end of the list
    //         lastNode.next = newNode;
    //     }
    //     return this;
    // };
    appendLast = (value) => {
        // create a new node with the provided data
        const newNode = new DLinkedListNode(value);
        // if the list is empty, set the new node as the first and last node
        if (!this.firstNode) {
            this.firstNode = newNode;
            this.lastNode = newNode;
        }
        else {
            // set the last node next node to the new node
            this.lastNode.next = newNode;
            // set the new node previous node to the original last node
            newNode.previous = this.lastNode;
            // set the last node as the new node
            this.lastNode = newNode;
        }
        return this;
    };

    // insert = (value, index=isRequired("index")) => {
    //     // create a new node with the provided data
    //     const newNode = new DLinkedListNode(value);
    //     // if the index is 0 or the list is empty ...
    //     if (index === 0 || !this.firstNode) {
    //         // set the new node as the first node
    //         newNode.next = this.firstNode;
    //         this.firstNode = newNode;
    //     }
    //     else {
    //         // look for the node before the one at the given index, or the last node
    //         let currentNode = this.firstNode;
    //         let currentIndex = 0;
    //         while (currentNode.next) {
    //             if (currentIndex === index - 1) {
    //                 break;
    //             }
    //             currentNode = currentNode.next;
    //             currentIndex++;
    //         }
    //         // insert the new node after the current node
    //         newNode.next = currentNode.next;
    //         currentNode.next = newNode;
    //     }
    //     return this;
    // };
    insert = (value, index=isRequired("index")) => {
        // create a new node with the provided data
        const newNode = new DLinkedListNode(value);
        // if the list is empty, set the new node as the first and last node
        if (!this.firstNode) {
            this.firstNode = newNode;
            this.lastNode = newNode;
        }
        else {
            if (index === 0) {
                // set the first node previous node to the new node
                this.firstNode.previous = newNode;
                // set the new node next node to the original first node
                newNode.next = this.firstNode;
                // set the first node as the new node
                this.firstNode = newNode;
            }
            else if (index > 0) {
                // look for the node before the one at the given index
                // if the index is out of range, pick the last node
                let currentIndex = 0;
                let currentNode = this.firstNode;
                while (currentNode.next) {
                    if (currentIndex === index - 1) {
                        break;
                    }
                    currentNode = currentNode.next;
                    currentIndex++;
                }
                if (currentNode === this.lastNode) {
                    // if the current node is the last one,
                    // set the last node next node to the new node
                    this.lastNode.next = newNode;
                    // set the new node previous node to the original last node
                    newNode.previous = this.lastNode;
                    // set the last node as the new node
                    this.lastNode = newNode;
                }
                else {
                    // otherwise, we're in the middle of the chain
                    // connect newNode to currentNode and currentNode.next
                    newNode.previous = currentNode;
                    newNode.next = currentNode.next;
                    // connect currentNode.next to newNode
                    currentNode.next.previous = newNode;
                    // connect currentNode to newNode
                    currentNode.next = newNode;
                }
            }
            else if (index === -1) {
                // set the last node next node to the new node
                this.lastNode.next = newNode;
                // set the new node previous node to the original last node
                newNode.previous = this.lastNode;
                // set the last node as the new node
                this.lastNode = newNode;
            }
            else {
                // look for the node after the one at the given index
                // if the index is out of range, pick the first node
                let currentIndex = -1;
                let currentNode = this.lastNode;
                while (currentNode.previous) {
                    if (currentIndex === index + 1) {
                        break;
                    }
                    currentNode = currentNode.previous;
                    currentIndex--;
                }
                if (currentNode === this.firstNode) {
                    // if the current node is the first one,
                    // set the first node previous node to the new node
                    this.firstNode.previous = newNode;
                    // set the new node next node to the original first node
                    newNode.next = this.firstNode;
                    // set the first node as the new node
                    this.firstNode = newNode;
                }
                else {
                    // otherwise, we're in the middle of the chain
                    // connect newNode to currentNode and currentNode.previous
                    newNode.next = currentNode;
                    newNode.previous = currentNode.previous;
                    // connect currentNode.previous to newNode
                    currentNode.previous.next = newNode;
                    // connect currentNode to newNode
                    currentNode.previous = newNode;
                }
            }
        }
        return this;
    };

    getValue = (index=isRequired("index")) => {
        // return the value at the given index (positive or negative)
        // if the index is out range, return "undefined"
        let value;
        if (index >= 0) {
            let currentNode = this.firstNode;
            let currentIndex = 0;
            while (currentNode) {
                if (currentIndex === index) {
                    value = currentNode.value;
                    break;
                }
                currentNode = currentNode.next;
                currentIndex++;
            }
        }
        else {
            let currentNode = this.lastNode;
            let currentIndex = -1;
            while (currentNode) {
                if (currentIndex === index) {
                    value = currentNode.value;
                    break;
                }
                currentNode = currentNode.previous;
                currentIndex--;
            }
        }
        return value;
    };

    setValue = (value, index=isRequired("index")) => {
        // set the value at the given index (positive or negative)
        // if the index is out range, don't do anthing
        if (index >= 0) {
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
        }
        else {
            let currentNode = this.lastNode;
            let currentIndex = -1;
            while (currentNode) {
                if (currentIndex === index) {
                    currentNode.value = value;
                    break;
                }
                currentNode = currentNode.previous;
                currentIndex--;
            }
        }
        return this;
    };

    clear = () => {
        this.firstNode = null;
        this.lastNode = null;
        return this;
    };

    popFirst = () => {
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.firstNode) {
            poppedValue = this.firstNode.value;
            // this.firstNode = this.firstNode.next;
            if (this.firstNode === this.lastNode) {
                // if the list only has 1 item, clear the list
                this.clear();
            }
            else {
                // set the first node as the 2nd node
                this.firstNode = this.firstNode.next;
                // set the first node previous node to "null"
                this.firstNode.previous = null;
            }
        }
        return poppedValue;
    };

    // popLast = () => {
    //     // if the list is empty, don't do anything
    //     // if the list has a single node, return its value and empty the list
    //     // if the list has at least 2 nodes, look for the node before the last one, return the last nodes's value and drop it
    //     let poppedValue;
    //     const listLength = this.length;
    //     if (listLength === 1) {
    //         poppedValue = this.firstNode.value;
    //         this.firstNode = null;
    //     }
    //     else if (listLength > 1) {
    //         let currentNode = this.firstNode;
    //         while (currentNode.next.next) {
    //             currentNode = currentNode.next;
    //         }
    //         poppedValue = currentNode.next.value;
    //         currentNode.next = null;
    //     }
    //     return poppedValue;
    // };
    popLast = () => {
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.lastNode) {
            poppedValue = this.lastNode.value;
            if (this.lastNode === this.firstNode) {
                // if the list only has 1 item, clear the list
                this.clear();
            }
            else {
                // set the last node as the second to last node
                this.lastNode = this.lastNode.previous;
                // set the last node next node to "null"
                this.lastNode.next = null;
            }
        }
        return poppedValue;
    };

    // pop = (index=isRequired("index")) => {
    //     let poppedValue;
    //     // if the index is not out of range ...
    //     if (index < this.length) {
    //         if (index === 0) {
    //             // pop the first node
    //             poppedValue = this.firstNode.value;
    //             this.firstNode = this.firstNode.next;
    //         }
    //         else {
    //             // find the node before the one at the provided index
    //             let currentNode = this.firstNode;
    //             let currentIndex = 0;
    //             while (currentIndex !== index - 1) {
    //                 currentNode = currentNode.next;
    //                 currentIndex++;
    //             }
    //             // pop the next node
    //             poppedValue = currentNode.next.value;
    //             currentNode.next = currentNode.next.next;
    //         }
    //     }
    //     return poppedValue;
    // };
    pop = (index=isRequired("index")) => {
        // if the index is out of range, doesn't do anything and returns "undefined"
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.firstNode) {
            if (index === 0) {
                poppedValue = this.popFirst();
            }
            else if (index > 0) {
                // find the node before the one at the given index
                let currentIndex = 0;
                let currentNode = this.firstNode;
                // while the current node is not the last one ...
                while (currentNode.next) {
                    if (currentIndex === index - 1) {
                        // set poppedValue as the value of the next node
                        poppedValue = currentNode.next.value;
                        if (currentNode.next === this.lastNode) {
                            // if the next node is the last node,
                            // set the last node as the current node
                            this.lastNode = currentNode;
                            // set the last node next node as "null"
                            this.lastNode.next = null;
                        }
                        else {
                            // otherwise,
                            // connect the current node with the one after the next node
                            currentNode.next = currentNode.next.next;
                            currentNode.next.previous = currentNode;
                        }
                        break;
                    }
                    currentNode = currentNode.next;
                    currentIndex++;
                }
            }
            else if (index === -1) {
                poppedValue = this.popLast();
            }
            else {
                // find the node after the one at the given index
                let currentIndex = -1;
                let currentNode = this.lastNode;
                // while the current node is not the first one ...
                while (currentNode.previous) {
                    if (currentIndex === index + 1) {
                        // set poppedValue as the value of the previous node
                        poppedValue = currentNode.previous.value;
                        if (currentNode.previous === this.firstNode) {
                            // if the previous node is the first node,
                            // set the first node as the current node
                            this.firstNode = currentNode;
                            // set the first node previous node as "null"
                            this.firstNode.previous = null;
                        }
                        else {
                            // otherwise,
                            // connect the current node with the one before the previous node
                            currentNode.previous = currentNode.previous.previous;
                            currentNode.previous.next = currentNode;
                        }
                        break;
                    }
                    currentNode = currentNode.previous;
                    currentIndex--;
                }
            }
        }
        return poppedValue;
    };

    // arr.forEach(function (item, index, array) {
    //     console.log(`${index}: ${item}`);
    //     console.log(array); // reference to arr
    //     // console.log(this); // undefined
    // });
    forEach = (callback=isRequired("callback")) => {
        let currentIndex = 0;
        let currentNode = this.firstNode;
        // while (currentIndex < this.length) {
        while (currentNode) {
            // callback(this.getValue(currentIndex), currentIndex, this);
            callback(currentNode.value, currentIndex, this);
            currentNode = currentNode.next;
            currentIndex++;
        }
    };

    static fromArray(array) {
        // create an empty list
        // we use "this[Symbol.species]()" here to create an object of the right species
        // const newLinkedList = new this();
        const newLinkedList = new this[Symbol.species]();
        // for each item in array ...
        array.forEach((value) => {
            // add the value to newLinkedList
            newLinkedList.appendLast(value);
        });
        return newLinkedList;
    }

    toArray = () => {
        // returns an array with each items in the list
        const arrayResult = [];
        // for each item in the list ...
        this.forEach((value) => {
            arrayResult.push(value);
        });
        return arrayResult;
    };

    // slice, concat, forEach, indexOf, lastIndexof, includes, findIndex, findLastIndex, filter, map, reduce
    // all methods that return a new linked list ("copy", "filter", "map", "concat", "slice") need to use the object constructor (this.constructor[Symbol.species])

    copy = () => {
        // returns a shallow copy of this list
        const newLinkedList = new this.constructor[Symbol.species]();
        this.forEach((value) => {
            newLinkedList.appendLast(value);
        });
        return newLinkedList;
    };

    concat = (...args) => {
        // "args" is an array of values to add to this linked list
        // can contain linked lists and/or other values
        // if linked list: add each item of the linked list to the this list
        // otherwise: add the item to the list
        // const resultLinkedList = new this.constructor[Symbol.species]();
        const resultLinkedList = this.copy();
        for (let item of args) {
            // console.log(item);
            if (item instanceof this.constructor) {
                item.forEach((value) => {
                    resultLinkedList.appendLast(value);
                });
            }
            else {
                resultLinkedList.appendLast(item);
            }
        }
        return resultLinkedList;
    };

    slice = (startIndex=0, lastIndex=Infinity) => {
        // returns a new linked list with a copy of every node from startIndex included to lastIndex excluded
        // if startIndex or lastIndex is negative, add this.length to it
        const listLength = this.length;
        startIndex = startIndex >= 0 ? startIndex : startIndex + listLength;
        lastIndex = lastIndex >= 0 ? lastIndex : lastIndex + listLength;
        // if either is still negative, set it to 0
        startIndex = startIndex >= 0 ? startIndex : 0;
        lastIndex = lastIndex >= 0 ? lastIndex : 0;
        // create an empty linked list
        const subList = new this.constructor[Symbol.species]();
        // add each item to it
        let currentIndex = 0;
        let currentNode = this.firstNode;
        while (currentNode && currentIndex < lastIndex) {
            if (currentIndex >= startIndex) {
                subList.appendLast(currentNode.value);
            }
            currentIndex++;
            currentNode = currentNode.next;
        }
        return subList;
    };

    indexOf = (value=isRequired("value"), fromIndex=0) => {
        // [].indexOf();
        // return the index of first occurence of "value" in the list, starting from "fromIndex"
        // if not found, return -1
        let foundAt = -1;
        let currentIndex = 0;
        let currentNode = this.firstNode;
        while (currentNode) {
            if (currentIndex >= fromIndex && currentNode.value === value) {
                foundAt = currentIndex;
                break;
            }
            currentIndex++;
            currentNode = currentNode.next;
        }
        return foundAt;
    };

    lastIndexOf = (value=isRequired("value"), fromIndex=null) => {
        // [].lastIndexOf();
        // same as "indexOf", but start looking from the end
    };

    includes = () => {};
    findIndex = () => {};
    findLastIndex = () => {};
    filter = () => {};
    map = () => {};
    reduce = () => {};
}

// tests
console.log('--- create new linked list');
let linkedList = new DLinkedList();
console.log(linkedList);
console.log('--- conversion to primitive');
// console.log(String(linkedList));
console.log(`${linkedList}`);
// console.log(Number(linkedList));
console.log(+linkedList);
// console.log(linkedList.getLength());
console.log('--- linkedList.length');
console.log(linkedList.length);
console.log('--- toStringTag');
console.log({}.toString.call(linkedList));
// linkedList.testIsInstance();
console.log('--- appendFirst');
linkedList.appendFirst(3).appendFirst(2).appendFirst(1);
console.log(`${linkedList}`);
console.log(linkedList.length);
console.log('--- appendLast');
linkedList.appendLast(4).appendLast(5);
console.log(`${linkedList}`);
console.log(linkedList.length);
console.log('--- insert');
linkedList.insert(0, 0).insert(6, 10000).insert(4.5, 5).insert(7, -1).insert(6.5, -2).insert(-1, -10000);
console.log(`${linkedList}`);
console.log(linkedList.length);
console.log('--- getValue');
console.log(linkedList.getValue(3));
console.log(linkedList.getValue(100));
console.log(linkedList.getValue(-1));
console.log(linkedList.getValue(-3));
console.log(linkedList.getValue(-1000));
console.log('--- setValue');
linkedList.setValue(-5, 0).setValue("abc", 5000).setValue(4.8, 6).setValue(10, -1).setValue(5.5, -4).setValue("kekw", -10000);
console.log(`${linkedList}`);
console.log('--- popFirst');
console.log(linkedList);
console.log(linkedList.popFirst());
console.log(`${linkedList}`);
console.log((new DLinkedList()).popFirst());
let testLinkedList = new DLinkedList("test");
console.log(testLinkedList.popFirst());
console.log(`${testLinkedList}`);
console.log(testLinkedList.popFirst());
console.log(`${testLinkedList}`);
console.log('--- popLast');
console.log(linkedList.popLast());
console.log(`${linkedList}`);
testLinkedList = new DLinkedList("test");
console.log(testLinkedList.popLast());
console.log(`${testLinkedList}`);
console.log(testLinkedList.popLast());
console.log(`${testLinkedList}`);
console.log('--- pop');
console.log(linkedList.pop(2));
console.log(`${linkedList}`);
console.log(linkedList.pop(1000));
console.log(`${linkedList}`);
console.log(linkedList.pop(0));
console.log(`${linkedList}`);
console.log(linkedList.pop(3));
console.log(`${linkedList}`);
console.log(linkedList.pop(-1));
console.log(`${linkedList}`);
console.log(linkedList.pop(-3));
console.log(`${linkedList}`);
console.log(linkedList.pop(-1000));
console.log(`${linkedList}`);
console.log('--- clear');
linkedList.clear();
console.log(`${linkedList}`);
console.log(linkedList.length);
console.log('--- test Symbol.species')
console.log(DLinkedList[Symbol.species]);
class PowerDLinkedList extends DLinkedList {
    // static get [Symbol.species]() {
    //     return DLinkedList;
    // }
}
console.log(PowerDLinkedList[Symbol.species]);
// let powerLinkedList = new PowerDLinkedList();
// let subPowerLinkedList = powerDLinkedList.slice();
let powerLinkedList = PowerDLinkedList.fromArray([1,2,3,4,5]);
console.log(powerLinkedList);
console.log(`${powerLinkedList}`);
let concatPowerLinkedList = powerLinkedList.concat(6,7,8);
console.log(concatPowerLinkedList);
console.log(`${concatPowerLinkedList}`);
console.log('--- constructor');
linkedList = new DLinkedList(1,2,3,4,5);
// linkedList = new DLinkedList(1,[2,3,4],5);
console.log(`${linkedList}`);
console.log(linkedList.length);
console.log('--- forEach');
linkedList.forEach((value, index, list) => {
    console.log(`${index}: ${value}`);
});
console.log('--- fromArray');
linkedList = DLinkedList.fromArray([1,2,3,4,5]);
console.log(`${linkedList}`);
console.log(linkedList.length);
console.log('--- toArray');
let array = linkedList.toArray();
console.log(array);
console.log('--- copy');
let linkedListCopy = linkedList.copy();
linkedList.appendLast(6);
console.log(`${linkedList}`);
console.log(`${linkedListCopy}`);
console.log('--- concat');
let newLinkedList = linkedList.concat(new DLinkedList(7,8,9), 10);
console.log(`${newLinkedList}`);
console.log('--- slice');
console.log(`${linkedList.slice(1, 3)}`);
console.log(`${linkedList.slice(1, 1888)}`); // till the end
console.log(`${linkedList.slice(-2)}`); // till the end
console.log(`${linkedList.slice(-2, 5)}`);
console.log(`${linkedList.slice(2, -1)}`);
console.log(`${linkedList.slice(-2000)}`); // entire array
console.log(`${linkedList.slice(-2000, 1)}`);
console.log(`${linkedList.slice(10000)}`); // empty array
console.log(`${linkedList.slice(1, -4000)}`); // empty array
console.log('--- indexOf');
console.log(linkedList.indexOf(5));
console.log(linkedList.indexOf(1));
console.log(linkedList.indexOf("lol"));
console.log(linkedList.indexOf(1, 1));
// */

/*
class PowerArray extends Array {
    // static get [Symbol.species]() {
    //     return DLinkedList;
    // }
}
console.log(Array[Symbol.species]);
console.log(PowerArray[Symbol.species]);
// */

/*
let arr = [1,2,3,4,5];
console.log(arr.slice(1, 3));
console.log(arr.slice(1, 18)); // till the end
console.log(arr.slice(-2)); // till the end
console.log(arr.slice(-2, 4));
console.log(arr.slice(2, -1));
console.log(arr.slice(-2000)); // entire array
console.log(arr.slice(-2000, 1));
console.log(arr.slice(180)); // empty array
console.log(arr.slice(1, -180)); // empty array
// */

/*
let arr = [1,2,3,4,5];
arr = arr.concat([6,7,8]);
// arr.concat(["lol"]);
console.log(arr);
// */

/*
let arr = new Array(1, [2,3,4], 5);
console.log(arr);
// */
