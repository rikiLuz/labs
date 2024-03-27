// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@hack/store/store.sol";
import "../../../src/wallet/BeitHaknesset.sol";

contract BeitHaknessetTest is Test{
    BeitHaknesset public wallet;
    

function setUp() public {
    address gabay1 = 0x7ae3DbAC75D264B6F6976639ebBfC645601D3F15; //itty fishman
    address gabay2 = 0xaC4E320Ed1235F185Bc6AC8856Ec7FEA7fF0310d; //meira
    address gabay3 = 0xad0091676Fa9631e1A74fE12E4a34325D1EdEB84; //homri
    wallet = new BeitHaknesset(gabay1, gabay2, gabay3);
    payable(address(wallet)).transfer(100);
}

function testReceive() public{
    address userAddress = vm.addr(1234);
    uint amount =100;
    vm.deal(userAddress, amount); //put money in randomAddress
    vm.startPrank(userAddress);
    uint256 initialBalance = address(wallet).balance; 
    payable(address(wallet)).transfer(50);
    uint256 currentBalance = address(wallet).balance;
    assertEq(initialBalance + 50,currentBalance);
    vm.stopPrank();
}


 function testNotAllowedWithDraw() public{
    uint256 amount=50;
    address userAddress= vm.addr(15);
    vm.startPrank(userAddress);
    uint256 initialWalletBalance = address(wallet).balance;
    vm.expectRevert();
    wallet.withDraw(amount);
    uint256 currentWalletBalance = address(wallet).balance;
    assertEq(initialWalletBalance, currentWalletBalance);
    vm.stopPrank();
}

function testAllowedWithDraw() public{

    address gabay= 0x7ae3DbAC75D264B6F6976639ebBfC645601D3F15;
    vm.startPrank(gabay);
    uint256 initialWalletBalance = address(wallet).balance;
    wallet.withDraw(50);
    uint256 currentWalletBalance = address(wallet).balance;
    assertEq(initialWalletBalance- 50, currentWalletBalance);
    vm.stopPrank();
}


function testChangeGabay() public {
    address owner= 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    address old_gabay = 0x7ae3DbAC75D264B6F6976639ebBfC645601D3F15;
    address new_gabay = 0x57C91e4803E3bF32c42a0e8579aCaa5f3762af71;

    vm.startPrank(owner);
    wallet.changeGabay(old_gabay,new_gabay);
    vm.expectRevert();

    wallet.changeGabay(old_gabay,new_gabay);
    assertEq(wallet.gabaim(new_gabay), true);
    assertEq(wallet.owner(), 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496);
    assertEq(wallet.gabaim(old_gabay), false);

    vm.stopPrank();

}

function testNotChangeGabay() public {
    address userAddress = vm.addr(13);
    address old_gabay = 0x7ae3DbAC75D264B6F6976639ebBfC645601D3F15;
    address new_gabay = 0x57C91e4803E3bF32c42a0e8579aCaa5f3762af71;

    vm.startPrank(userAddress);
    vm.expectRevert();
    wallet.changeGabay(old_gabay,new_gabay);

    assertEq(wallet.gabaim(old_gabay), true);
    vm.stopPrank();

}

function testgetBalance() public {
    assertEq(wallet.getBalance(), 100, "not equals");
}
    

}
