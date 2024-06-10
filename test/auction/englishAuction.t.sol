
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../../src/auction/englishAuction.sol";
import "@openzeppelin/ERC721/IERC721.sol";
import "../../../src/auction/MyToken.sol";

contract testAuctions is Test {
    struct Auction {
        address seller;
        bool started;
        bool ended;
        uint256 endAt;
        address highestBidder;
        uint256 highestBid;
        uint256 tokenID;
        address[] addresses;
    }

    MyToken token;
    Auctions a;
    address adr1 = address(123);

    function setUp() public {
        token = new MyToken();
        a = new Auctions(address(token));
        token.mint(adr1, 111);
        vm.prank(adr1);
        token.approve(address(a), 111);
    }

    function testStartAuction() public {
        vm.startPrank(adr1);
        vm.warp(1);
        token.approve(address(a), 111);
        a.startAuction(111, 7 * 20 * 60 * 60);
        (
            address seller,
            bool started,
            bool ended,
            uint256 endAt,
            address highestBidder,
            uint256 highestBid,
            uint256 tokenID
        ) = a.auctions(111);
        console.log(seller);
        assert(seller==adr1);
        assert(started==true);
        assert(ended==false);
        assert(endAt==block.timestamp + 7 * 20 * 60 * 60);
        assert(highestBid==0);
        assert(highestBidder==address(0));
        assert(tokenID==111);
        assert(token.ownerOf(tokenID) == address(a));
        // vm.expectEmit(tokenID, endAt);
    }
    function testPlaceBid() public {
        vm.warp(1);
        vm.prank(adr1);
        a.startAuction(111, 7*60*60*24);
        vm.deal(address(2), 200);
        vm.prank(address(2));
        a.placeBid{value: 100}(111);
    }
}
