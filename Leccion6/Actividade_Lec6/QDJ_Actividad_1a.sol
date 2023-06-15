// SPDX-License-Identifier: MIT
pragma solidity <0.9;

contract actividad1{
    
    struct llista{
        string message;
        string fecha;
    }
    // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
    mapping(address=>llista[]) private mensajes;

    constructor(){
        //mensajes[msg.sender].push(llista({message:"HOLA",fecha:"23/12/2023"}));
    }
    function getMessage(address addr, uint index) public view returns (string memory,string memory){
        
        if(mensajes[addr].length>0 && index < mensajes[addr].length){
            return (string.concat("Mensaje: ",mensajes[addr][index].message), string.concat(" Fecha: ",mensajes[addr][index].fecha));
        }
        else{
            return ("Lista de Mensajes vacia.","");
        }
    }

    function addMessage(address emisor, string memory texto, string memory fecha) public {     
        if(mensajes[emisor].length<1){
            mensajes[emisor].push(llista({message:texto,fecha:fecha}));
        }
        else{
            mensajes[emisor].push(llista({message:texto,fecha:fecha}));
        }
    }

    function deleteMessage(address emisor) public {
        if(mensajes[emisor].length>0){
            mensajes[emisor].pop();
        }
    }

}
