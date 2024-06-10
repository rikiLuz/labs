// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/ERC20/IERC20.sol";

contract AMM {
    address public owner;
    IERC20 public immutable tokenA;
    IERC20 public immutable tokenB;
    uint256 public amountA;
    uint256 public amountB;
    bool isInitialized;
    uint256 kFactors;
    uint256 constant WAD = 10 ** 18;
    //אחוז הנזילות שכתובת ארנק סיפקה
    mapping(address => uint256) public liquidityProviders;

    constructor(IERC20 tA, IERC20 tB, uint256 aA, uint256 aB) {
        owner = msg.sender;
        tokenA = IERC20(tA);
        tokenB = IERC20(tB);
        initialize(aA, aB);
    }

    function initialize(uint256 initializeA, uint256 initializeB) private {
        require(
            initializeA > 0 && initializeB > 0 && initializeA == initializeB,
            "InitialA and initialB must be greater than zero."
        );
        require(isInitialized == false, "");
        amountA = initializeA;
        amountB = initializeB;
        kFactors = initializeA;
        isInitialized = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not authorized");
        _;
    }

    function tradeAToB(uint256 amount) public payable {
        //   require();
        tokenA.transferFrom(msg.sender, address(this), amount);
        tokenB.transfer(msg.sender, amountB - kFactors / amountA);
    }

    function tradeBToA(uint256 amount) public payable {}

    function addLiquidity(uint256 value) public payable {
        // require(tA > 0 && tB > 0 && tA == tB, "The sum of the coins must be bigger than zero and equal");
        require(value > 0, "The sum of the coins must be bigger than zero");
        uint256 amountTA = (WAD * value / price(tokenA));
        uint256 amountTB = (WAD * value / price(tokenB));
        require(
            tokenA.balanceOf(msg.sender) >= amountTA && tokenB.balanceOf(msg.sender) >= amountTB,
            "You don't have enough money"
        );
        tokenA.transferFrom(msg.sender, address(this), amountTA);
        tokenB.transferFrom(msg.sender, address(this), amountTB);
        liquidityProviders[msg.sender] = value;
        amountA += amountTA;
        amountB += amountTB;
        kFactors += value;
    }

    function removeLiquidity(uint256 value) public {
        require(value > 0, "The sum of the coins must be bigger than zero");
        require(value <= liquidityProviders[msg.sender], "You don't have enough liquidity to pull");
        // uint percent = WAD * liquidityProviders[msg.sender] / kFactors**2 ;
        uint256 amountTA = (WAD * value / price(tokenA));
        uint256 amountTB = (WAD * value / price(tokenB));
        tokenA.transfer(msg.sender, amountTA);
        tokenB.transfer(msg.sender, amountTB);
        amountA -= amountTA;
        amountB -= amountTB;
        kFactors -= value;
    }
    //ערך למטבע

    function price(IERC20 token) public view returns (uint256) {
        return WAD * kFactors / token.balanceOf(address(this));
    }
}
