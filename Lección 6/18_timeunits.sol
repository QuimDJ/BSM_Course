// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract ejemploVariablesGlobales {
    
    uint public referenceday;
    bool public active = false;

    constructor(uint cantidad) {
        referenceday = block.timestamp + cantidad * 1 minutes;//days;
    }
    function activate() public returns(bool){
         if (referenceday <= block.timestamp) {
             active = true;
             return true;
         }else {
             return false;
         }
     }
     function pendinTime() public view returns (uint){
         return referenceday -  block.timestamp;
     }
}
