// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract beitHKenesset {
    address payable public owner;
    mapping(address => bool) public gabaim;

    constructor( address gabay1 , address gabay2, address gabay3) {
        owner = payable (msg.sender);
        gabaim[gabay1]=true;
        gabaim[gabay2]=true;
        gabaim[gabay3]=true;
    }

    receive() external payable {}

    function withDraw(uint256 amount) external {
        require(msg.sender==owner||gabaim[msg.sender]==true);
        require(address(this).balance >= amount,"not enough eth to withdraw");
        payable(msg.sender).transfer(amount);
    }

    function changeGabay(address old_gabay , address new_gabay) public {
        require (msg.sender==owner,"you...");
        require (gabaim[new_gabay]==false, "you already inside")
        gabaim[old_gabay]=false;
        gabaim[new_gabay]=true;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
