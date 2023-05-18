// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.18;

contract ejemploVariablesGlobales {
    
    address public creador = msg.sender;
    uint public initialvalue;
  //  uint public  current_time = now;
    uint public  current_time_2 = block.timestamp;
    uint public  bloque_numero  = block.number;
    uint public  bloque_randao = block.prevrandao;
    uint public  gaslimit = block.gaslimit;
    uint public bloque_basefee = block.basefee;
    address public realCreator = tx.origin;
    bytes public data = msg.data;

    constructor() payable {
        initialvalue = msg.value;
    }
    function setData(uint ) public {
        data = msg.data;
    }

    function get_transaction_gas(uint iteration) public view returns( uint , uint , uint) {
        uint initialGas = gasleft();
        uint aux = 0;
        for(uint i =0; i<iteration;i++){
            aux++;
        }
        uint finalgas = gasleft();
        return (initialGas,finalgas,initialGas-finalgas);
    }

    function getblocinfo() public view returns (uint,uint) {  //doesnt return the creation block, aprox the current
        return (block.number,block.timestamp);
    }
    
}