// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract message{
    string public Mensaje;

    function getMessage() public view returns (string memory){
        return Mensaje;
    }

    function setMessage(string memory nuevoMensaje) public{
        Mensaje = nuevoMensaje;
        }

}