// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.18;


contract ejemploTransferEther {
    
    mapping(address => uint) public balance;
    event Retirada(address receptor, uint256 amount);
    
    
    function addEthers() public payable {
       balance[msg.sender] += msg.value;
    }
    
    function getContractbalance() public view returns (uint) {
        return (address(this).balance);
    }
       
    
    function retrieveEthers(uint amount) public {        
        address payable destinatario = payable(msg.sender);
        balance[destinatario] -= amount;
        payable(destinatario).transfer(amount);
    }

    function retrieveEthersv2(uint amount) public {        
        address payable destinatario = payable(msg.sender);
        balance[destinatario] -= amount;
        if(!payable(destinatario).send(amount))
            revert("Error en envio");
        //assert(destinatario.send(amount));
    }

    
}