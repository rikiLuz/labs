
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.19;

import "@openzeppelin/ERC20/IERC20.sol";
import "@openzeppelin/ERC20/extensions/ERC20Permit.sol";

contract DAI is ERC20 {
    constructor() ERC20("Dai", "DAI") {}

    function mint(address add, uint256 amount) public {
        _mint(add, amount);
    }
    function burn(address add, uint amount) public {
        _burn(add, amount);
    }
}
