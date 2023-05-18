//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.19;

contract Messagebox {
    string public message;
    
    constructor ()  {
        message = "HELLO WORLD!";
    }
    
    function setMessage(string memory _new_message) public {    
         message = _new_message;
    }
    
    function getMessage() public view returns (string memory) {
        return message;
    }
    
}

