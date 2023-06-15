// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;
/*test with f([1,1,1,1,1,1,1,1,1,1]) */

contract C {
    uint[] public x; // the data location of x is storage
    uint public aux1;
    uint public aux2;
    uint public aux3;
    uint public aux4;
    uint public aux5;
    uint public aux6;
    uint public aux7;
    
    // the data location of memoryArray is memory
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // works, copies the whole array to storage
        uint[] storage y = x; // works, assigns a pointer, data location of y is storage
        x[6] = 3;
        y[7] = 3; //modifies 8th element 
        
       // delete x; // fine, clears the array, also modifies y
        delete y[3];

        aux1 = g(x); // calls g, handing over a reference to x
        aux2 = h(x); // calls h and creates an independent, temporary copy in memory
        aux3 = x[3];
        aux4 = x[4];
        aux5 = x[5];
        aux6 = y[6];
        aux7 = y[7];
    }
    function getArray() public view returns(uint [] memory) {
        return x;
    }


    function g(uint[] storage var_x) internal  returns (uint){  
        var_x[4] = 3; 
		return var_x.length;
	}
    function h(uint[] memory var_x) public  pure returns (uint) { //doesnt change the state
        var_x[5] = 3; 
        return var_x.length;
    }

   
}