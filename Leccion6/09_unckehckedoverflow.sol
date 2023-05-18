// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract contrato1 {

    uint public valor = 0;
    
    function suma(uint _valor) public{
        valor += _valor;
    }
    function resta(uint _valor) public{
        valor -= _valor;
    }
    function uncheckedSuma(uint _valor) public{
       unchecked{valor += _valor;} 
    }
    function uncheckedResta(uint _valor) public{
         unchecked{valor -= _valor;} 
    }
    
}