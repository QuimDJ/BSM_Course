// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

contract EjemploFixedArrays {
    
    uint[3] public v_ia;
    
    function init_arrays() public {
        uint[3] memory a = [uint(1),2,3];
        v_ia =  a;
    }

    
    function setFixedIntArray(uint8 index, uint value) public {
        v_ia[index] = value;
    }
   
	function getNumberElementsArray () public view returns ( uint intarray) {
		return  ( v_ia.length);
	}
	
	function getArray() public view returns (uint[3] memory){
	    return v_ia;
	}
    
    function newArray(uint[3] memory a) public {
        v_ia =  a;
    }

    function usingMemoryArray() public view returns (uint[] memory) {
       
        uint[] memory b = new uint[](v_ia.length);
       
        b[2] = 8;

        return b;
    }
}
