
//SPDX-License-Identifier: MIT
// import "@openzeppelin/ERC721/ERC721.sol";
import "@openzeppelin/ERC721/IERC721.sol";

pragma solidity ^0.8.19;

contract Auctions {
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

    IERC721 public token;
    mapping(uint256 => mapping(address => uint256)) public bids;
    mapping(uint256 => Auction) public auctions;

    event start(uint256 tokenID, uint256 endAt);
    event bid(uint256 tokenID, address bidder, uint256 amount);
    event withdraw(uint256 tokenID, address bidder);
    event end(uint256 tokenID, address winner);

    constructor(address _token) {
        token = IERC721(_token);
    }

    function startAuction(uint256 _tokenID, uint256 duration) external {
        require(auctions[_tokenID].seller == address(0), "can't duplicate auction");
        require(duration > 0, "duration can't be 0");
        require(token.ownerOf(_tokenID) == msg.sender, "sender not owns the NFT");
        address[] memory a;
        auctions[_tokenID] = Auction({
            seller: msg.sender,
            started: true,
            ended: false,
            endAt: block.timestamp + duration,
            highestBid: 0,
            highestBidder: address(0),
            tokenID: _tokenID,
            addresses: a
        });
        token.transferFrom(msg.sender, address(this), _tokenID);
        emit start(_tokenID, auctions[_tokenID].endAt);
    }

    function placeBid(uint256 tokenID) external payable {
        require(auctions[tokenID].seller != address(0), "auction does not exist");
        require(auctions[tokenID].started && block.timestamp < auctions[tokenID].endAt, "inactive auction");
        require(msg.sender.balance >= msg.value, "no money");
        require(msg.value + bids[tokenID][msg.sender] > auctions[tokenID].highestBid, "lower bid");
        payable(address(this)).transfer(msg.value);
        bids[tokenID][msg.sender] = bids[tokenID][msg.sender] + msg.value;
        auctions[tokenID].highestBid = bids[tokenID][msg.sender];
        auctions[tokenID].highestBidder = msg.sender;
        auctions[tokenID].addresses.push(msg.sender);
        emit bid(tokenID, msg.sender, bids[tokenID][msg.sender]);
    }

    function withdrawBid(uint256 tokenID) external {
        require(bids[tokenID][msg.sender] != 0, "sender didn't place bid");
        require(auctions[tokenID].highestBidder != msg.sender, "highest bitter can't withdraw bid");
        payable(msg.sender).transfer(bids[tokenID][msg.sender]);
        delete bids[tokenID][msg.sender];
        emit withdraw(tokenID, msg.sender);
    }

    function endAuction(uint256 tokenID) external {
        require(
            auctions[tokenID].started && auctions[tokenID].endAt <= block.timestamp && !auctions[tokenID].ended,
            "auction does not end"
        );
        auctions[tokenID].ended = true;
        bool isSeller = auctions[tokenID].highestBid == 0;
        token.transferFrom(
            address(this), isSeller ? auctions[tokenID].seller : auctions[tokenID].highestBidder, tokenID
        );
        if (!isSeller) {
            payable(auctions[tokenID].seller).transfer(auctions[tokenID].highestBid);
        }
        delete bids[tokenID][auctions[tokenID].highestBidder];
        for (uint256 i = 0; i < auctions[tokenID].addresses.length; i++) {
            if (bids[tokenID][auctions[tokenID].addresses[i]] > 0) {
                payable(auctions[tokenID].addresses[i]).transfer(bids[tokenID][auctions[tokenID].addresses[i]]);
            }
        }
        emit end(tokenID, auctions[tokenID].highestBidder);
    }

}
