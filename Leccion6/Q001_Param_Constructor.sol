// SPDX-License-Identifier: MIT

pragma solidity >0.6 <=0.9;

contract p1{

    string public nom;

    constructor(string memory _nom){
        nom = _nom;
    }

    function quinNom() public view returns (string memory){
        return nom;
    }
}
