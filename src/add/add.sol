//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Add {
    constructor() {}

    function addTwo(uint256 x, uint256 y)pure public returns (uint256) {
        return x + y;
    }
}