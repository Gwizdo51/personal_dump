"use strict";

/*
2 problems :
- get the list of all the prime numbers between 0 and a given number
- decompose a given number into its product of primes
*/

function eratosthenesSieve(n) {
    let tempArray = [];
    const resultArray = [];
    // fill tempArray with all the natural numbers from 2 to n
    for (let i = 2; i <= n; i++) {
        tempArray.push(i);
    }
    while (tempArray.length) {
        // the first number of tempArray is a prime, add it to resultArray
        let nextPrime = tempArray.shift();
        resultArray.push(nextPrime);
        // remove all multiples of nextPrime from tempArray
        tempArray = tempArray.filter((item) => item % nextPrime !== 0);
    }
    return resultArray;
}

const primesUpTo10k = eratosthenesSieve(10000);
console.log(primesUpTo10k);

function isPrime(n) {
    // get all the primes up to the square root of n
    const potentialDivisors = eratosthenesSieve(Math.floor(Math.sqrt(n)));
    // n is a prime <=> no prime up to sqrt(n) divides n
    return potentialDivisors.every((value) => n % value !== 0);
}

console.log(isPrime(347));

function primeFactors(n) {
    const potentialDivisors = eratosthenesSieve(Math.floor(Math.sqrt(n)));
    return primeFactorsRecursive(n, potentialDivisors);
}

function primeFactorsRecursive(n, potentialDivisors) {
    if (n === 1) {
        return [];
    }
    let divisor = null;
    for (let potentialDivisor of potentialDivisors) {
        if (n % potentialDivisor === 0) {
            divisor = potentialDivisor;
            break;
        }
    }
    if (divisor) {
        return [divisor].concat(primeFactorsRecursive(n / divisor, potentialDivisors));
    }
    else {
        return [n];
    }
}

// console.log(primeFactors(128782));
console.log(primeFactors(221));
console.log(primeFactors(4096));
console.log(primeFactors(4095));
