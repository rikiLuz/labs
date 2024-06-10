// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/console.sol";
import "@openzeppelin/ERC721/ERC721.sol";
import "@openzeppelin/ERC20/ERC20.sol";
import "/home/user/Documents/labs/src/audit/approve.sol"
import "./TokenNFT.sol";

//import "./SafeMath.sol";\


contract Auction is IERC20 {
  
    struct suggest{

        bool flag;
        uint amount;
        uint tokenId;


    }
    address payable private owner;
    mapping(address => suggest) public suggestions;
    uint256 max;
    bool start=false;
    uint end;
    address[] public stack;    
    uint256 public constant SEVEN_DAYS = 604800;// שבעה ימים בשניות של קיום המכירה
    address winnerAddress;
    TokenNFT public nft;
     constructor() {
        owner = payable(msg.sender);
        end = block.timestamp + SEVEN_DAYS;
        start = true;
        nft= new TokenNFT();
  
       
    }
    modifier onlyOwner(){
        require(
            owner == msg.sender ,
            "Only the owner and the gabaim allowed to withdraw Ether");
            _;
    }

    //הכנסת הצעה חדשה
    function addSuggest(uint amount, uint tokenId) public {

        require(start , "The auction doesnt start");
        if(block.timestamp < end){
            //הכנסת הצעה חדשה רק במקרה שההצעה הקודמת קטנה ממנה
            require (suggestions[stack[stack.length]].amount < amount, "You should offer a higher amount");
              
                //במקרה שהמציע כבר קיים
            if (suggestions[msg.sender].amount > 0 ){ 

                uint lastSuggest = suggestions[msg.sender].amount;
                require(msg.sender.balance >= amount , "you do not have enough money");
                suggestions[msg.sender].amount = amount;
                suggestions[msg.sender].tokenId = tokenId;
                 //קבלת הכסף של ההצעה החדשה של לקוח קיים
                 transferFrom(msg.sender,address(this),amount);
                 //החזרת הכסף של ההצעה הקודמת
                payable(suggestions[msg.sender]).transfer(lastSuggest);                     
                stack.push(msg.sender);
            }
            else {//משתמש חדש

                require(msg.sender.balance >=amount , "you do not have enough money");
                suggestions[msg.sender].amount= amount;
                suggestions[msg.sender].tokenId = tokenId;
                suggestions[msg.sender].flag = true;
                //קבלת הכסף מהמשתמש
                transferFrom(msg.sender, address(this) , amount);
                stack.push(msg.sender);
            }
       }
       else{
            start=false;
            endAuction();
        }

    }
    //הסרת הצעה
    function removeSugget() public {

        require(start , "The auction doesnt start");
        require(block.timestamp < end , "The Auction is over");
        require(suggestions[msg.sender].flag == true, "");
            //החזרת הסף למשתמש לאחר ההסרה
            payable(suggestions[msg.sender]).transfer(suggestions[msg.sender].amount);    
            suggestions[msg.sender].flag = false;
        }


    // פונקציה שמתבצעת רק כאשר עוברים שבעה ימים מהפעלת החוזה
    function endAuction() external onlyOwner{

        uint i= stack.length; 
        for(;i>=0 && suggestions[stack[i]].flag == false; i--){}
        winnerAddress = stack[i];
        //nft.approve(stack[i],suggestions[stack[i]].tokenId);
        nft.transferFrom(address(this),stack[i], suggestions[stack[i]].tokenId);
        for(uint j= i-1; j>=0; j--){
            if(suggestions[stack[i]].flag)
            //החזרת הכסף לכל ההצעות שלא זכו לאחר סיום המכירה
             payable(suggestions[stack[j]]).transfer(suggestions[stack[j]].amount);         
        }

    }
}