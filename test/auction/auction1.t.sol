//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;
import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/ERC721/ERC721.sol";
import "/home/user/Documents/labs/src/auction/nft.sol";
import "/home/user/Documents/labs/src/auction/auction.sol";

contract AuctionTest is Test {

    Auction public auction;
    address public owner= address(123);
    TokenNFT public nft;
    uint tokenId=1;
 
    function setUp() public {
        // Deploy NFT and ERC721 contracts for testing

        vm.startPrank(owner);
        auction = new Auction(); 
         string memory name = "Sari";
         string memory symbole = "orit";
        erc721 = new MyERC721(name, symbole);
        erc721.mint(owner, tokenId);
        erc721.approve(address(auction), tokenId);
    }

    function testAddSuggest()public{

        uint amount = 1000;
        address userAddress= vm.addr(1234);
        vm.startPrank(userAddress);
        vm.deal(userAddress,amount);
        auction.addSuggest(amount);
        assertEq(auction.stack[auction.stack.length].amount, 1000, "the amount is not equal");
        vm.stopPrank();
    }

    function testRemoveSuggest(){
           
       address userAddress= vm.addr(12345);
       vm.startPrank(userAddress);
       vm.deal(userAddress,2000);
       auction.addSuggest(2000);
       auction.removeSugget();
       assertEq(auction.suggestions[userAddress].flag, false, "the suggest is not remove");
       vm.stopPrank();
    }
    
    function testEndAuction(){
       
       auction.endAuction();
       assertEq(address(auction).balance,0, "the balance of the contract is not zero" );
       assertEq(nft.ownerof(tokenId),auction.winnerAddress,"the token NFT did not move to winner");
    }


}