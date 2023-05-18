// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.4;

contract testContract {
   
    constructor() payable {

    }

    function getbalance() public view returns (uint,uint) {
        return (address(this).balance, msg.sender.balance);
    }

     function getcode() public view returns (bytes memory,bytes memory) {
        return (address(this).code, msg.sender.code);
    }
    function getcodeHash() public view returns (bytes32 ,bytes32) {
        return (address(this).codehash , msg.sender.codehash );
    }

    function retrieveEther() public {
        payable(msg.sender).transfer(address(this).balance-1);
    }
    
    
}