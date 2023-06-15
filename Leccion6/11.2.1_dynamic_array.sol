// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;
contract Example {
    uint[][] public ListOfLists;

    function getArray(uint index) public view returns(uint[] memory)
    {
        return ListOfLists[index];
    }

    function addElement2Array(uint index, uint value) public {
        ListOfLists[index].push(value);
    }
    function totalLists() public view returns(uint) {
        return ListOfLists.length;
    }
    function addList(uint[] memory a) public {
        ListOfLists.push(a);
    }
}