// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.18;

contract EjemploMapping2 {
    
     struct User {
        string nombre;
        uint8 edad;
        string useralias;
    }
    
    mapping(address => User) public walletProfile;
    
    function setProfile(string memory _nombre, uint8 _edad, string memory _useralias) public {
        walletProfile[msg.sender] =   User({nombre:_nombre, edad:_edad,useralias:_useralias}); 
		// User(_nombre,_edad,_useralias);
    }

    function getProfile() public view returns(User memory)
    {
        return walletProfile[address(msg.sender)];
    }
    
}
  