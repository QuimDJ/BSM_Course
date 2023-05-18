pragma solidity >=0.4.22 <0.6.0;

contract contrato1 {

    uint public valor = 0;
    
    function suma(uint _valor) public{
        valor += _valor;
    }
    function resta(uint _valor) public{
        valor -= _valor;
    }
  
}