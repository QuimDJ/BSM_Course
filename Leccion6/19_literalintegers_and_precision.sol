// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

uint128 constant X = 32**22 + 8;

contract C {
    
    
   function usingStringLiterals(uint128 a) public pure returns(uint128 )  {
       uint128 b = 2e18*a+X;     // 2e10 == 2*10**18
       return  b;
   }

    function calculWithPrecision(uint a, uint b, uint precision) public pure returns ( uint) {

     return a*(10**precision)/b;    /*    7/3 with a precision of 5 it will output 233333 which means 7/3=2.33333  */
    }

    function getValue() public pure returns (uint) {
        return 5/2+0.5;
    }
    /*
    function getValue2(uint a, uint b) public pure returns (uint) {
        return (a/b)+0.5;
    }*/

}