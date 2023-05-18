// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

uint constant X = 32**22 + 8;

contract C {
    uint public x;
    constructor(uint _x) {
        x = _x;
    }

    function changeX(uint _otherx) public  returns (uint) {
        x = _otherx;
        return x;
    }

    function getX() public view returns (uint) {
        return x;
    } 

    function changeY(uint _otherx) public pure returns (uint) {
       uint  y = _otherx;
        return y;
    } 

   function recivedonation() external payable returns(uint){
       x = msg.value;
       return x;
   }

}