
// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;
import "./storageSlot.sol";
contract Proxy {
    bytes32 private constant IMPLEMENTATION_SLOT = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
    bytes32 private constant ADMIN_SLOT = bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);
    constructor () {
        _setAdmin(msg.sender);
    }
    modifier ifAdmin() {
        if (msg.sender == _getAdmin()) {
            _;
        }
        else {
            _fallback();
        }
    }
    function _getAdmin() private view returns (address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }
    function _setAdmin(address _admin) private {
        require(_admin != address(0), "admin=zero address");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }
    function _getImplementation() private view returns (address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }
    function _setImplementation(address _implementation) private {
        require(_implementation.code.length > 0, "implementation is not contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }
    function changeAdmin(address _admin) external ifAdmin {
        _setAdmin(_admin);
    }
    function upgradeTo(address _implementation) external ifAdmin {
        _setImplementation(_implementation);
    }
    function admin() external ifAdmin returns (address) {
        return _getAdmin();
    }
    function implementation() external ifAdmin returns (address) {
        return _getImplementation();
    }
    function _delegate(address _implementation) internal virtual {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                 return(0, returndatasize())
            }
        }
    }
    function _fallback() private {
        _delegate(_getImplementation());
    }
    fallback() external payable {
        _fallback();
    }
    receive() external payable {
        _fallback();
    }
}
