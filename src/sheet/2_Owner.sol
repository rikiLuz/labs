
//*what is it?? SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.15;

/**
 * title Owner
 * @dev Set & change owner
 */
contract Owner {
    address private owner;
    // event for logs by EVM
    //* what is EVM?

    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    // modifier to ensure that the caller is the owner

    modifier isOwner() {
        // arg#1 "if sentence"
        // arg#2 error message
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    /**
     * @dev Set contract deployer as owner
     */

    constructor() {
        // sender of current call, contract deployer for the constructor
        owner = msg.sender;
        emit OwnerSet(address(0), owner);
    }
    /**
     *
     * @dev Change owner
     * @param newOwner address of new owner
     */

    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }
    /**
     * @dev Return owner address
     * @return address of owner
     */
    //* what is external??

    function getOwner() external view returns (address) {
        return owner;
    }
}
