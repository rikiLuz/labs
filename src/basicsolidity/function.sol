// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;



contract function{


    function returnMany() public pure return(uint256, bool, uint256){

        return(1,true,5);
    }


    function named() public pure return( uint256 x, bool flag , uint256 y){
        return(1,true,7)
    }



    function assigned() public pure return( uint256 x, bool flag , uint256 y){
        x = 5;
        flag = false;
        y = 7;
    }





}