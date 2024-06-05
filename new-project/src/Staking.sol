// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "C:\Users\ריקי לוז\Desktop\labs\new-project\src\myToken.sol";

contract Pool_Staking is MTK  {

    address public userStaker;
    uint256 public pool=0;
    uint256 constant finalDate= 1740225600;//יצוג תאריך בסולידיטי עי שניות שחלפו משנת  30.05.24 1970
    mapping(address => Staker) public stakers;//מאפינג של יוזרים שלכל יוזר יש מערך הפקדות


    struct Deposit {//הפקדה אחת
        uint256 currentAmount;
        uint256 date;
    }
    struct Staker {//מערך הפקדות לכל יוזר
        Deposit[] depositsArr;
        uint256 depositsSum = 0;


    }

    constructor() {

    }

    function Deposit() public payable {

        require(msg.value>0, "You must send some Ether to pool");
        stakers[msg.sender].depositsArr.push(Deposit(msg.value, block.timestamp));//הכנסה למערך הפקדות
        console.log(block.timestamp);
        pool += msg.value;
        stakers[msg.sender].DepositSum += msg.value;

    }

    function withDraw(uint256 amount) external {
        uint256 rewards = calcRewards(amount);
        payable(msg.sender).transfer(amount+rewards);
        pool -= amount;
    }

    function calcRewards(uint256 amount) external {

        uint256 sum = 0; 
        for (uint256 i = 0; i <= stakers[msg.sender].depositsArr.length && sum <= amount ; i++ ){
            if(stakers[msg.sender].depositsArr[i].date >= finalDate)//כל עוד תאריך ההפקדה בוצע לפני התאריך הסופי
                if((block.timestamp - (stakers[msg.sender].depositsArr[i].date)) >= 608400)//אם עברו יותר מ7 ימים (מוצג בשניות)
                    sum += stakers[msg.sender].depositsArr[i].amount;
        }

        if(sum > amount)
            sum = amount;

        sum    

 

    }
}
