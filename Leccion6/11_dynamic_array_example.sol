// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.18;

contract EjemploDynamicdArrays {
    
    string public v_s;
    int[] public  v_da;
    
    
    function init_arrays() public {
        v_s = "helloWorld";
        v_da.push(1);
        v_da.push(2);
    }

    
	function addArray(int value) public {
	   v_da.push(value);
	}
	
	function setArrayIndex(uint8 index, int value) public {
        v_da[index] = value;
    }
	
	function getArray() public view returns (int[] memory) {
	    return v_da;
	}

	function getIndexArray(uint index) public view returns (int ){
	    return v_da[index];
	}
	
	/*
	function getNumberElements () public view returns (uint astring, uint dynamicArray) {
		return  (v_s.length,v_da.length);
	}*/
	function getNumberElementsArray () public view returns ( uint dynamicArray) {
		return  (v_da.length);
	}
	
	function delete_element(uint index) public {
	    if(index < v_da.length)
	    {
	        for(uint i = index; i < v_da.length - 1; i++) {
	            v_da[i] = v_da[i+1];
	        }
	      //  v_da.length--;  //deprecated
          v_da.pop();
	    } 
	}
	
}