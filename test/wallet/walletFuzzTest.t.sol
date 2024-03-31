// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/store/store.sol";

import "../../src/wallet/gabaim.sol";

contract BeitHaknessetFuzzTest is Test{
    BeitHaknesset public wallet;
    

function setUp(address gabay1, address gabay2, address gabay3 ) public {
    wallet = new BeitHaknesset(gabay1, gabay2, gabay3);
    payable(address(wallet)).transfer(100);
}

function fuzzTestReceive(uint256 amount) public{
    console.log(amount);
    address userAddress = vm.addr(1234);
    vm.deal(userAddress, amount); //put money in randomAddress
    vm.startPrank(userAddress);
    uint256 initialBalance = address(wallet).balance; 
    payable(address(wallet)).transfer(50);
    uint256 currentBalance = address(wallet).balance;
    assertEq(initialBalance + 50,currentBalance,"not equal");
    vm.stopPrank();
}


 function fuzzTestNotAllowedWithDraw(uint256 amount) public{
    console.log(amount);
    address userAddress= vm.addr(15);
    vm.startPrank(userAddress);
    uint256 initialWalletBalance = address(wallet).balance;
    vm.expectRevert();
    wallet.withDraw(amount);
    uint256 currentWalletBalance = address(wallet).balance;
    assertEq(initialWalletBalance, currentWalletBalance);
    vm.stopPrank();
}

function fuzzTestAllowedWithDraw(address gabay) public{
    vm.startPrank(gabay);
    uint256 initialWalletBalance = address(wallet).balance;
    wallet.withDraw(50);
    uint256 currentWalletBalance = address(wallet).balance;
    assertEq(initialWalletBalance- 50, currentWalletBalance);
    vm.stopPrank();
}


function fuzzTestChangeGabay(address owner, address old_gabay,address new_gabay) public {
  
    vm.startPrank(owner);
    wallet.changeGabay(old_gabay,new_gabay);
    vm.expectRevert();

    wallet.changeGabay(old_gabay,new_gabay);
    assertEq(wallet.gabaim(new_gabay), true);
    assertEq(wallet.owner(), 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
    assertEq(wallet.gabaim(old_gabay), false);

    vm.stopPrank();

}

function fuzzTestNotChangeGabay(address userAddress,address old_gabay, address new_gabay) public {
    vm.startPrank(userAddress);
    vm.expectRevert();
    wallet.changeGabay(old_gabay,new_gabay);

    assertEq(wallet.gabaim(old_gabay), true);
    vm.stopPrank();

}

function fuzzTestgetBalance() public {
    assertEq(wallet.getBalance(), 100, "not equals");
}
    

}