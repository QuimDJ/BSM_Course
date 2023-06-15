//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8;

contract Messagebox {
    string[] private mensajes;
    address private _admin;
    mapping(address => uint) userTotalMensajes;
    uint pago = 0.001 ether;
    uint[] private fechaUnixUltimoMensaje;

    constructor ()  {
        _admin = msg.sender;
    }

    modifier soloAdmin(uint _idMensaje) {
        require(msg.sender == _admin);
        _;
    }  
    function addMessage(string memory _nuevoMensaje) public payable {    
         if(userTotalMensajes[msg.sender] == 0){
            mensajes.push(_nuevoMensaje);
            fechaUnixUltimoMensaje.push(block.timestamp);
            userTotalMensajes[msg.sender]++;
         }else{
            require(msg.value-pago >= 0);
            payable(msg.sender).transfer(msg.value-pago);
            mensajes.push(_nuevoMensaje);
            userTotalMensajes[msg.sender]++;
            fechaUnixUltimoMensaje.push(block.timestamp);
         }
    }  
    function getMessage(uint _idMensaje) public view returns (string memory) {
        return mensajes[_idMensaje];
    }
    function mostraMensajes() public view returns (string[] memory) {
        return mensajes;
    }
    function mostrarFechaUltimoMensaje() public view returns (uint) {
        return fechaUnixUltimoMensaje[fechaUnixUltimoMensaje.length-1];
    }

    function borrarMensaje(uint _idMensaje) public soloAdmin(_idMensaje) {
        require(_idMensaje <= mensajes.length);
        for(uint i=_idMensaje; i<mensajes.length-1; i++) {
            mensajes[i] = mensajes[i+1];
            fechaUnixUltimoMensaje[i] = fechaUnixUltimoMensaje[i+1];
        }
        mensajes.pop();
        fechaUnixUltimoMensaje.pop();
        userTotalMensajes[msg.sender]--;
    }
}