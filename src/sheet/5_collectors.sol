
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Collectors {
    address public owner;
    address[] public collectors;
    uint256 numCollectors;

    constructor() {
        owner = msg.sender;
        collectors = new address[](3);
        numCollectors = 0;
    }

    modifier isAllowed() {
        require(isCollector(msg.sender) || isOwner(msg.sender), "sender is not allowed");
        _;
    }

    function isCollector(address sender) private view returns (bool) {
        bool allowed = false;
        for (uint256 i = 0; i < 3; i++) {
            if (collectors[i] == sender) {
                allowed = true;
            }
        }
        return allowed;
    }

    function isOwner(address sender) private view returns (bool) {
        return sender == owner;
    }

    function deposit(uint256 amount) public payable returns (uint256) {
        require(amount > 0, "can't donate a negative amount");
        payable(address(this)).transfer(amount);
        return address(this).balance;
    }

    function withdraw() public payable isAllowed {
        require(address(this).balance >= msg.value, "There is not enough");
        payable(msg.sender).transfer(msg.value);
    }

    function addCollector(address newCollector) public {
        require(msg.sender == owner, "You don't have permission to add another collector");
        require(numCollectors < 3, "there is enough collectors yet.");
        require(!isCollector(newCollector), "this collector is allowed yet");
        collectors[numCollectors++] = newCollector;
    }
}
