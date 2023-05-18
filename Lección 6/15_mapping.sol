// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.18;

contract EjemploMapping {
        
    mapping(address => int) public wallets;
    
    function setValue(address walletAddress, int value) public {
        wallets[walletAddress] = value;
    }
    
}
    
  