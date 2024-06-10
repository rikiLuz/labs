
pragma solidity ^0.8.19;
import "@openzeppelin/ERC20/IERC20.sol";
import "../stake/MyERC20.sol";

contract Lending{
    address owner;
    IERC20 public DAI;
    MyToken public bond; 
    // mapping(address=>uint) public 
    mapping(address=>uint) public borrows;
    mapping(address=>uint) public collaterals;


    modifier onlyOwner() {
        require(msg.sender==owner, "not owner");
        _;
    }
    constructor(address _DAI) {
        DAI = IERC20(_DAI);
    }
    // USER: deposit DAI into the lending protocol and receive bond tokens in return.
    // Scenario: Alice wants to earn interest on her DAI holdings. She deposits 100 DAI into the protocol and receives corresponding bond tokens.
    function deposit() public {

    }
    // USER: unbond bond tokens and receive DAI in return.
    // Scenario: Bob decides to withdraw some of his deposited DAI. He burns 50 bond tokens and receives 50 DAI in return.
    function unbond(uint amount) public {

    }
    // USER: add ETH as collateral to borrow assets from the protocol.
// Scenario: Charlie wants to borrow DAI. He adds 1 ETH as collateral to the protocol, enabling him to borrow up to a certain limit.
    function addCollateral() public {

    }
    // USER: remove ETH collateral from the protocol.
    // Scenario: Dave decides to remove some of his collateral from the protocol. He withdraws 0.5 ETH from his collateral pool.
    function removeCollateral(uint amount) public {

    }
    // USER: borrow assets from the protocol using my deposited collateral.
    // Scenario: Eve needs to borrow 100 DAI. She has sufficient ETH collateral deposited in the protocol, allowing her to borrow the desired amount.
    function borrow(uint amount) public {

    }
    // USER: repay borrowed assets to reduce my debt.
    // Scenario: Frank has borrowed 50 DAI from the protocol. He repays the entire amount along with the applicable borrowing fee.
    function repay() public {

    }
    /////////// owner /////////////////

    // OWNER: trigger liquidation of user positions when their collateral value falls below a certain threshold.
    // Scenario: The protocol owner observes that a user's borrowed amount exceeds their collateral value beyond the specified maximum loan-to-value ratio. The owner initiates liquidation of the user's position to recover the borrowed assets.
    function liquidation() public onlyOwner {

    }
    // OWNER: harvest(get) rewards accrued by the protocol.
    // Scenario: The protocol has accumulated rewards=aWETH tokens. The owner harvests these rewards and converts them to ETH.
    function getRewards() public onlyOwner {

    }
    // OWNER: convert protocol treasury ETH to reserve assets.
    // Scenario: The protocol has accumulated ETH in its treasury. The owner converts a portion of this ETH to DAI and adds it to the protocol's reserve.
    // function {

    // }
}
