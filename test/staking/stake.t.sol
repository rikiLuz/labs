
//SPDX-Licenes-Identifier: MIT
pragma solidity ^0.8.19;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../../src/stake/MyERC20.sol";
import "@hack/stake/stake.sol";

contract TestStake is Test {
    Stake stake;
    MyToken token;
    address person1;
    address person2;
    address person3;
    // mapping(address=>uint) stakedAmounts;

    function setUp() public {
        token = new MyToken();
        stake = new Stake(address(token));
        person1 = address(123);
        person2 = address(456);
        person3 = address(789);
        console.log(stake.owner());
        // stakedAmounts = stake.stakedAmounts();
    }

    function testStake() public {
        vm.startPrank(person1);
        vm.deal(person1, 11000);
        vm.warp(1735689600);
        stake.mint(person1, 11000);
        uint256 prevBlPerson1 = token.balanceOf(address(person1));
        uint256 prevBalance = token.balanceOf(address(stake));
        uint256 preveTotalStake = stake.totalStaked();
        console.log(token.balanceOf(person1));
        token.approve(address(stake), 5000);
        stake.stake{value: 5000}();
        console.log(stake.beginDates(person1));
        assertEq(stake.stakedAmounts(person1), 5000);
        assertEq(stake.beginDates(person1) / 60 / 60 / 24, block.timestamp / 60 / 60 / 24);
        assertEq(stake.totalStaked(), preveTotalStake + 5000);
        assertEq(prevBlPerson1 - 5000, token.balanceOf(person1));
        assertEq(prevBalance + 5000, token.balanceOf(address(stake)));
        // vm.stopPrank();
    }

    function teststakeFall() public {
        //vm.startPrank(person1)
        vm.expectRevert("must be positive amount");
        stake.stake{value: 0}();
        console.log("gggggggggggggg");
    }

    function testStakFallNoMoney() public {
        vm.startPrank(person1);
        vm.deal(person1, 100000);
        stake.mint(person1, 10);
        console.log("p", token.balanceOf(person1));
        token.approve(address(stake), 5000);
        vm.expectRevert("no money");
        stake.stake{value: 5000}();
        vm.stopPrank();
    }

    function testWithDraw() public {
        uint256 beginDate = 1735689600;
        vm.warp(beginDate);
        vm.startPrank(person1);
        stake.mint(person1, 100000);
        vm.deal(person1, 100000);

        console.log("balance:", token.balanceOf(address(stake)));
        // vm.warp(beginDate);
        token.approve(address(stake), 10000);
        stake.stake{value: 10000}();
        vm.stopPrank();

        vm.startPrank(person2);
        stake.mint(person2, 100000);
        vm.deal(person2, 100000);
        token.approve(address(stake), 5000);
        stake.stake{value: 5000}();
        vm.stopPrank();

        vm.startPrank(person3);
        stake.mint(person3, 100000);
        vm.deal(person3, 100000);
        token.approve(address(stake), 5000);
        stake.stake{value: 5000}();
        uint256 prevBl = token.balanceOf(person3);
        vm.warp(beginDate + 8 * 24 * 60 * 60);
        stake.withdraw();
        console.log("person1", token.balanceOf(person1));
        console.log("person2", token.balanceOf(person2));
        console.log("person3", token.balanceOf(person3));
        assertEq(token.balanceOf(person3), prevBl + 5000 + 250000);
        // vm.expectRevert();
        // stake.withdraw();
    }

    function testWithDrawFall() public {
        vm.startPrank(person1);
        vm.expectRevert("you didn't stake anything");
        stake.withdraw();
    }

    function testWithDrawFllLocked() public {
        uint256 beginDate = 1735689600;
        vm.warp(beginDate);
        vm.startPrank(person1);
        stake.mint(person1, 100000);
        vm.deal(person1, 100000);
        token.approve(address(stake), 10000);
        stake.stake{value: 10000}();
        vm.warp(beginDate + 2 * 24 * 60 * 60);
        vm.expectRevert("Your money is still locked.");
        stake.withdraw();
    }
}
