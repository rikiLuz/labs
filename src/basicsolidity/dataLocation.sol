// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract dataLocation{

uint256[] public arr;
mapping (uint256 => address) map;


struct myStruct{
    uint256 foo;
}

mapping(uint256 => myStruct) myMapStruct;

function f () public{
     
     _f(arr,map,myMapStruct[1]);

    myStruct storage myStruct = myMapStruct[1];
    myStruct memory myMemStruct = myMapStruct (0);

}

function _f(uint256[] storage _arr, mapping(uint256 => address) storage _map, myStruct storage _myStruct) internal {

}

function g(uint256 memory _arr) public return (uint256[] memory){
    
}

}