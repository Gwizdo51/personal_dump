"use strict";

// function isRequired(parameterName) {
//     throw new Error(`parameter "${parameterName}" is required`);
// }

// rewrite the linked list code as a class
class DLinkedListNode {

    // protect the "value", "next" and "previous" properties
    #value;
    #next;
    #previous;

    constructor(value=DLinkedList.isRequired('value'), previous=null, next=null) {
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

    // protect "firstNode", "lastNode" and "length" properties and set to null on instance creation
    #firstNode = null;
    #lastNode = null;
    #length = 0

    static isRequired(parameterName) {
        throw new Error(`parameter "${parameterName}" is required`);
    }

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

    get _firstNode() {
        return this.#firstNode;
    }

    set _firstNode(firstNode) {
        // "firstNode" must either be "null" or an instance of "DLinkedListNode"
        if (firstNode !== null && !(firstNode instanceof DLinkedListNode)) {
            throw new Error(`"firstNode" must be either "null" or an instance of "${DLinkedListNode}"`);
        }
        this.#firstNode = firstNode;
    }

    get _lastNode() {
        return this.#lastNode;
    }

    set _lastNode(lastNode) {
        // "lastNode" must either be "null" or an instance of "DLinkedListNode"
        if (lastNode !== null && !(lastNode instanceof DLinkedListNode)) {
            throw new Error(`"lastNode" must be either "null" or an instance of "${DLinkedListNode}"`);
        }
        this.#lastNode = lastNode;
    }

    get length() {
        return this.#length;
    }

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
            let currentNode = this._firstNode;
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

    appendFirst = (value) => {
        // create a new node with the provided data
        const newNode = new DLinkedListNode(value);
        // if the list is empty, set the new node as the first and last node
        if (!this.length) {
            this._firstNode = newNode;
            this._lastNode = newNode;
        }
        else {
            // set the first node previous node to the new node
            this._firstNode.previous = newNode;
            // set the new node next node to the original first node
            newNode.next = this._firstNode;
            // set the first node as the new node
            this._firstNode = newNode;
        }
        // increment this.#length
        this.#length++;
        return this;
    };

    appendLast = (value) => {
        // create a new node with the provided data
        const newNode = new DLinkedListNode(value);
        // if the list is empty, set the new node as the first and last node
        if (!this.length) {
            this._firstNode = newNode;
            this._lastNode = newNode;
        }
        else {
            // set the last node next node to the new node
            this._lastNode.next = newNode;
            // set the new node previous node to the original last node
            newNode.previous = this._lastNode;
            // set the last node as the new node
            this._lastNode = newNode;
        }
        // increment this.#length
        this.#length++;
        return this;
    };

    insert = (value, index=DLinkedList.isRequired("index")) => {
        // create a new node with the provided data
        const newNode = new DLinkedListNode(value);
        // if the list is empty, set the new node as the first and last node
        if (!this.length) {
            this._firstNode = newNode;
            this._lastNode = newNode;
        }
        else {
            if (index === 0) {
                // set the first node previous node to the new node
                this._firstNode.previous = newNode;
                // set the new node next node to the original first node
                newNode.next = this._firstNode;
                // set the first node as the new node
                this._firstNode = newNode;
            }
            else if (index > 0) {
                // look for the node before the one at the given index
                // if the index is out of range, pick the last node
                let currentIndex = 0;
                let currentNode = this._firstNode;
                while (currentNode.next) {
                    if (currentIndex === index - 1) {
                        break;
                    }
                    currentNode = currentNode.next;
                    currentIndex++;
                }
                if (currentNode === this._lastNode) {
                    // if the current node is the last one,
                    // set the last node next node to the new node
                    this._lastNode.next = newNode;
                    // set the new node previous node to the original last node
                    newNode.previous = this._lastNode;
                    // set the last node as the new node
                    this._lastNode = newNode;
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
                this._lastNode.next = newNode;
                // set the new node previous node to the original last node
                newNode.previous = this._lastNode;
                // set the last node as the new node
                this._lastNode = newNode;
            }
            else {
                // look for the node after the one at the given index
                // if the index is out of range, pick the first node
                let currentIndex = -1;
                let currentNode = this._lastNode;
                while (currentNode.previous) {
                    if (currentIndex === index + 1) {
                        break;
                    }
                    currentNode = currentNode.previous;
                    currentIndex--;
                }
                if (currentNode === this._firstNode) {
                    // if the current node is the first one,
                    // set the first node previous node to the new node
                    this._firstNode.previous = newNode;
                    // set the new node next node to the original first node
                    newNode.next = this._firstNode;
                    // set the first node as the new node
                    this._firstNode = newNode;
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
        // increment this.#length
        this.#length++;
        return this;
    };

    _getNode = (index=DLinkedList.isRequired("index")) => {
        // return the node at the given index (positive or negative)
        // if the index is out of range, return "null"
        let node = null;
        if (index >= this.length || index < -this.length) {
            return node;
        }
        if (index >= 0) {
            let currentNode = this._firstNode;
            let currentIndex = 0;
            while (currentNode) {
                if (currentIndex === index) {
                    node = currentNode;
                    break;
                }
                currentNode = currentNode.next;
                currentIndex++;
            }
        }
        else {
            let currentNode = this._lastNode;
            let currentIndex = -1;
            while (currentNode) {
                if (currentIndex === index) {
                    node = currentNode;
                    break;
                }
                currentNode = currentNode.previous;
                currentIndex--;
            }
        }
        return node;
    };

    getValue = (index=DLinkedList.isRequired("index")) => {
        // return the value at the given index (positive or negative)
        // if the index is out range, return "undefined"
        return this._getNode(index)?.value;
    };

    setValue = (value, index=DLinkedList.isRequired("index")) => {
        // set the value at the given index (positive or negative)
        // if the index is out range, don't do anything
        const node = this._getNode(index);
        if (node) {
            node.value = value;
        }
        return this;
    };

    clear = () => {
        this._firstNode = null;
        this._lastNode = null;
        this.#length = 0;
        return this;
    };

    popFirst = () => {
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.length) {
            poppedValue = this._firstNode.value;
            // this._firstNode = this._firstNode.next;
            if (this.length === 1) {
                // if the list only has 1 item, clear the list
                this.clear();
            }
            else {
                // set the first node as the 2nd node
                this._firstNode = this._firstNode.next;
                // set the first node previous node to "null"
                this._firstNode.previous = null;
                // decrement this.#length
                this.#length--;
            }
        }
        return poppedValue;
    };

    popLast = () => {
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.length) {
            poppedValue = this._lastNode.value;
            if (this.length === 1) {
                // if the list only has 1 item, clear the list
                this.clear();
            }
            else {
                // set the last node as the second to last node
                this._lastNode = this._lastNode.previous;
                // set the last node next node to "null"
                this._lastNode.next = null;
                // decrement this.#length
                this.#length--;
            }
        }
        return poppedValue;
    };

    pop = (index=DLinkedList.isRequired("index")) => {
        // if the index is out of range, doesn't do anything and returns "undefined"
        let poppedValue;
        // can only pop a value if the list is not empty
        if (this.length) {
            if (index === 0) {
                poppedValue = this.popFirst();
            }
            else if (index > 0) {
                // find the node before the one at the given index
                let currentIndex = 0;
                let currentNode = this._firstNode;
                // while the current node is not the last one ...
                while (currentNode.next) {
                    if (currentIndex === index - 1) {
                        // set poppedValue as the value of the next node
                        poppedValue = currentNode.next.value;
                        if (currentNode.next === this._lastNode) {
                            // if the next node is the last node,
                            // set the last node as the current node
                            this._lastNode = currentNode;
                            // set the last node next node as "null"
                            this._lastNode.next = null;
                        }
                        else {
                            // otherwise,
                            // connect the current node with the one after the next node
                            currentNode.next = currentNode.next.next;
                            currentNode.next.previous = currentNode;
                        }
                        // decrement this.#length
                        this.#length--;
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
                let currentNode = this._lastNode;
                // while the current node is not the first one ...
                while (currentNode.previous) {
                    if (currentIndex === index + 1) {
                        // set poppedValue as the value of the previous node
                        poppedValue = currentNode.previous.value;
                        if (currentNode.previous === this._firstNode) {
                            // if the previous node is the first node,
                            // set the first node as the current node
                            this._firstNode = currentNode;
                            // set the first node previous node as "null"
                            this._firstNode.previous = null;
                        }
                        else {
                            // otherwise,
                            // connect the current node with the one before the previous node
                            currentNode.previous = currentNode.previous.previous;
                            currentNode.previous.next = currentNode;
                        }
                        // decrement this.#length
                        this.#length--;
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
    forEach = (callback=DLinkedList.isRequired("callback")) => {
        let currentIndex = 0;
        let currentNode = this._firstNode;
        // while (currentIndex < this.length) {
        while (currentNode) {
            // callback(this.getValue(currentIndex), currentIndex, this);
            callback(currentNode.value, currentIndex, this);
            currentNode = currentNode.next;
            currentIndex++;
        }
    };

    some = (callback=DLinkedList.isRequired("callback")) => {
        // runs the callback for each item of the list as long as it returns false
        // stops as soon at the function returns true
        // return false if all calls of the callback returned false, return true otherwise
        let currentIndex = 0;
        let currentNode = this._firstNode;
        let any = false;
        // let callbackReturnValue;
        while (currentNode) {
            // callbackReturnValue = callback(currentNode.value, currentIndex, this);
            if (callback(currentNode.value, currentIndex, this)) {
                any = true;
                break;
            }
            currentIndex++;
            currentNode = currentNode.next;
        }
        return any;
    };

    static fromArray(array=DLinkedList.isRequired("array")) {
        // /!\ cannot make a list from an array that contains any "undefined"
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
        startIndex = startIndex >= 0 ? startIndex : startIndex + this.length;
        lastIndex = lastIndex >= 0 ? lastIndex : lastIndex + this.length;
        // if either is still negative, set it to 0
        startIndex = startIndex >= 0 ? startIndex : 0;
        lastIndex = lastIndex >= 0 ? lastIndex : 0;
        // create an empty linked list
        const subList = new this.constructor[Symbol.species]();
        // add each item to it
        let currentIndex = 0;
        let currentNode = this._firstNode;
        while (currentNode && currentIndex < lastIndex) {
            if (currentIndex >= startIndex) {
                subList.appendLast(currentNode.value);
            }
            currentIndex++;
            currentNode = currentNode.next;
        }
        return subList;
    };

    indexOf = (value, fromIndex=0) => {
        // [].indexOf();
        // return the index of first occurence of "value" in the list, starting from "fromIndex"
        // "fromIndex" can be positive or negative (array is still searched front to back)
        // if not found, return -1
        // if fromIndex is negative, add this.length to it
        fromIndex = fromIndex >= 0 ? fromIndex : fromIndex + this.length;
        // if still negative, set to 0
        fromIndex = fromIndex >= 0 ? fromIndex : 0;
        let currentNode = this._getNode(fromIndex);
        let foundAt = -1;
        let currentIndex = fromIndex;
        // while the end of the list has not been reached ...
        while (currentNode) {
            // if the value has been found after "fromIndex" ...
            if (currentNode.value === value) {
                // return the index the value was found at
                foundAt = currentIndex;
                break;
            }
            // keep looking
            currentIndex++;
            currentNode = currentNode.next;
        }
        return foundAt;
    };

    lastIndexOf = (value, fromIndex=-1) => {
        // Array.prototype.lastIndexOf();
        // same as "indexOf", but start looking from the end
        // "fromIndex" is the highest index the value can be found at
        // TODO: this is wrong, check def of [].lastIndexOf()
        // if fromIndex is negative, add this.length to it
        fromIndex = fromIndex >= 0 ? fromIndex : fromIndex + this.length;
        // if still negative, set to 0
        fromIndex = fromIndex >= 0 ? fromIndex : 0;
        let currentNode = this._getNode(fromIndex);
        let foundAt = -1;
        let currentIndex = fromIndex;
        // while the start of the list has not been reached ...
        while (currentNode) {
            // if the value has been found before "fromIndex" ...
            if (currentNode.value === value) {
                // return the index the value was found at
                foundAt = currentIndex;
                break;
            }
            // keep looking
            currentIndex--;
            currentNode = currentNode.previous;
        }
        return foundAt;
    };

    includes = (value, fromIndex=0) => {
        // returns true if the value is found in the list
        // start looking from fromIndex
        // TODO: "fromIndex" can be positive or negative (array is still searched front to back)
        // TODO: use "this._getNode"
        // if fromIndex is negative, add this.length to it
        fromIndex = fromIndex >= 0 ? fromIndex : fromIndex + this.length;
        // if still negative, set to 0
        fromIndex = fromIndex >= 0 ? fromIndex : 0;
        let currentNode = this._getNode(fromIndex);
        let valueFound = false;
        let currentIndex = fromIndex;
        // while the end of the list has not been reached ...
        while (currentNode) {
            // if the value has been found after "fromIndex" ...
            if (currentNode.value === value) {
                valueFound = true;
                break;
            }
            // keep looking
            currentIndex++;
            currentNode = currentNode.next;
        }
        return valueFound;
    };

    findIndex = () => {};
    findLastIndex = () => {};
    filter = () => {};
    map = () => {};
    reduce = () => {};
}

// /*
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
console.log(`${linkedList} (${linkedList.length})`);
console.log('--- appendLast');
linkedList.appendLast(4).appendLast(5);
console.log(`${linkedList} (${linkedList.length})`);
console.log('--- insert');
linkedList.insert(0, 0).insert(6, 10000).insert(4.5, 5).insert(7, -1).insert(6.5, -2).insert(-1, -10000);
console.log(`${linkedList} (${linkedList.length})`);
console.log('--- getValue');
console.log(linkedList.getValue(3));
console.log(linkedList.getValue(100));
console.log(linkedList.getValue(-1));
console.log(linkedList.getValue(-3));
console.log(linkedList.getValue(-1000));
console.log('--- setValue');
linkedList.setValue(-5, 0).setValue("abc", 5000).setValue(4.8, 6).setValue(10, -1).setValue(5.5, -4).setValue("kekw", -10000);
console.log(`${linkedList} (${linkedList.length})`);
console.log('--- popFirst');
// console.log(linkedList);
console.log(linkedList.popFirst());
console.log(`${linkedList} (${linkedList.length})`);
console.log((new DLinkedList()).popFirst());
let testLinkedList = new DLinkedList("test");
console.log(testLinkedList.popFirst());
console.log(`${testLinkedList} (${testLinkedList.length})`);
console.log(testLinkedList.popFirst());
console.log(`${testLinkedList} (${testLinkedList.length})`);
console.log('--- popLast');
console.log(linkedList.popLast());
console.log(`${linkedList} (${linkedList.length})`);
testLinkedList = new DLinkedList("test");
console.log(testLinkedList.popLast());
console.log(`${testLinkedList}`);
console.log(testLinkedList.popLast());
console.log(`${testLinkedList}`);
console.log('--- pop');
console.log(linkedList.pop(2));
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.pop(1000));
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.pop(0));
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.pop(3));
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.pop(-1));
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.pop(-3));
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.pop(-1000));
console.log(`${linkedList} (${linkedList.length})`);
console.log('--- clear');
linkedList.clear();
console.log(`${linkedList} (${linkedList.length})`);
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
console.log(`${linkedList} (${linkedList.length})`);
console.log('--- forEach');
linkedList.forEach((value, index, list) => {
    console.log(`${index}: ${value}`);
});
console.log('--- some');
let any = linkedList.some((value, index) => {
    console.log(value);
    return false;
});
console.log(any);
any = linkedList.some((value, index) => {
    console.log(value);
    if (value === 3) {
        return true;
    }
    return false;
});
console.log(any);
console.log('--- fromArray');
linkedList = DLinkedList.fromArray([1,2,3,4,5]);
console.log(`${linkedList} (${linkedList.length})`);
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
let tempLinkedList;
tempLinkedList = linkedList.slice(1, 3);
console.log(`${tempLinkedList} (${tempLinkedList.length})`);
tempLinkedList = linkedList.slice(1, 1888);
console.log(`${tempLinkedList} (${tempLinkedList.length})`); // till the end
tempLinkedList = linkedList.slice(-2);
console.log(`${tempLinkedList} (${tempLinkedList.length})`); // till the end
tempLinkedList = linkedList.slice(-2, 5);
console.log(`${tempLinkedList} (${tempLinkedList.length})`);
tempLinkedList = linkedList.slice(2, -1);
console.log(`${tempLinkedList} (${tempLinkedList.length})`);
tempLinkedList = linkedList.slice(-2000);
console.log(`${tempLinkedList} (${tempLinkedList.length})`); // entire array
tempLinkedList = linkedList.slice(-2000, 1);
console.log(`${tempLinkedList} (${tempLinkedList.length})`);
tempLinkedList = linkedList.slice(10000);
console.log(`${tempLinkedList} (${tempLinkedList.length})`); // empty array
tempLinkedList = linkedList.slice(1, -4000);
console.log(`${tempLinkedList} (${tempLinkedList.length})`); // empty array
console.log('--- indexOf');
linkedList = DLinkedList.fromArray([1,2,1,2,1,2]);
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.indexOf(1));
console.log(linkedList.indexOf(2));
console.log(linkedList.indexOf(3));
console.log(linkedList.indexOf(1, 2));
console.log(linkedList.indexOf(1, -3));
console.log(linkedList.indexOf(1, -100000));
console.log('--- lastIndexOf');
console.log(`${linkedList} (${linkedList.length})`);
console.log(linkedList.lastIndexOf(1));
console.log(linkedList.lastIndexOf(2));
console.log(linkedList.lastIndexOf(3));
console.log(linkedList.lastIndexOf(1, 0));
console.log(linkedList.lastIndexOf(1, -3));
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
let arr = [1,1,2,1,2,1];
console.log(arr.lastIndexOf(1, 4));
// */

/* can I break a forEach loop?
let arr = [1,2,3,4,5];
// arr.forEach((value) => {
//     if (value === 3) {
//         console.log("found");
//         break;
//     }
// });
// "some" can be used for that purpose
arr.some((value) => {
    console.log(value);
    if (value === 3) {
        return true;
    }
    return false;
});
// */
