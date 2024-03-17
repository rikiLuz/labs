// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract beitHKenesset {
    address payable[] public owners;
    mapping(address => uint256) public balances;

    constructor() {
        for (uint256 i = 0; i < owners.length; i++) {
            owners[i] = payable(msg.sender);
        }
    }

    receive() external payable {}

    function withDraw(uint256 amount) external {
        for (uint256 i = 0; i < owners.length; i++) {
            require(msg.sender == owners[i], "WALLET-not-owner");
            require(address(this).balance >= amount, "you dont have enough money");
            balances[msg.sender] -= amount;
            payable(msg.sender).transfer(amount);
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
