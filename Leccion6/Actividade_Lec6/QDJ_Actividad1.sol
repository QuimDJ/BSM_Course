// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract actividad1{
    
    struct llista{
        string message;
        uint fecha;
    }
    address private _owner;
    uint public ultimafecha;
    mapping(address=>llista[]) private mensajes;
    uint private totalElemLlista;
    address[] private emisores;
    uint constant pago = 0.001 ether;

    constructor(){
        _owner=msg.sender;
    }
    function getMessage(address addr, uint index) public view returns (string memory,uint){
        
        if(mensajes[addr].length>0 && index < mensajes[addr].length){
            return (string.concat("Mensaje: ",mensajes[addr][index].message),mensajes[addr][index].fecha);
        }
        if(index!=0 && index >= mensajes[addr].length){
            return ("Indice incorrecto para la Lista de Mensajes.",0);
        }
        else{
            return ("Lista de Mensajes vacia.",0);
        }
    }
    
     function addMessage(string memory texto) external payable {
        if(mensajes[msg.sender].length<1){

            mensajes[msg.sender].push(llista({message:texto,fecha:block.timestamp}));
            totalElemLlista+=1;
            emisores.push(msg.sender);
        }
        else{
            require(msg.value>=pago);
            payable(msg.sender).transfer(msg.value - pago);
            mensajes[msg.sender].push(llista({message:texto,fecha:block.timestamp}));
            totalElemLlista+=1;

        }
        ultimafecha=block.timestamp;
    }

    function deleteMessage(address d, uint id) public {
        require(msg.sender==_owner);
        if(mensajes[_owner].length>0){
            delete mensajes[d][id];
        }
    }

    function mostrarMensajes() public view returns(string memory msgs){
        msgs="";
        for(uint i=0;i<totalElemLlista;i++){
            for(uint j=0;j<emisores.length;j++){
                msgs=string.concat(msgs,", ",mensajes[emisores[j]][i].message);
            }
        } 
        return msgs;
    }

    function MostraMensajesEmisor(uint idEmisor) public view returns (llista[] memory) {
        llista[] storage l;
        l = mensajes[emisores[idEmisor]];
        return l;
    }
    function addrEmisor(uint idEmisor) public view returns (address) {
        return emisores[idEmisor];
    }

    function t1() public view returns (string[] memory ls){
        uint cuenta=0;
        for(uint i=0;i<totalElemLlista;i++){
            for(uint j=0;j<emisores.length;j++){
                //msgs=string.concat(msgs,", ",mensajes[emisores[j]][i].message);
                ls[cuenta+=1]=mensajes[emisores[j]][i].message;
            }
        } 
        return ls;
    }


}
