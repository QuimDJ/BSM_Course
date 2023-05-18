// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.1;

uint constant X = 32**22 + 8;

contract C {
    string constant public TEXT = "abc";
    bytes32 constant public MY_HASH = keccak256("abc");
    uint immutable public decimals;
    uint immutable public maxBalance;  //uint constant public maxBalance;
    address immutable public owner = msg.sender;

    constructor(uint _decimals, address _reference) {
        decimals = _decimals;
        // Assignments to immutables can even access the environment.
        maxBalance = _reference.balance;
    }

    function isBalanceTooHigh(address _other) public view returns (bool, uint) {
        return (_other.balance > maxBalance, X);
    }

   /* function tryChangeImmutable(uint newMaxBalance) public {
        maxBalance = 10000;
    }
    */
}