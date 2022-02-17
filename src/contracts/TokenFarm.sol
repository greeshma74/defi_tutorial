pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    // All code goes here....

    string public name = "Dapp Token Farm";
    address public owner;
    DappToken public dappToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    // Allow TokenFarm to know about Dapp and Dai token, so grab address
    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        // _dappToken and _daiToken are the address of the smart contract
        // These address are available locally, To make it global, we are storing the address values below
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // 1. Stack Tokens (Deposit)
    function stakeTokens(uint _amount) public {
        // code goes inside here

        // Require amount greater tahn 0
        require(_amount > 0, "amount cannot be 0");

        // transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Add users to stakers array only if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Updating Staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }




    // 2. Unstaking Tokens (WithDraw)

    function unstakeTokens() public {

        //fetch staking balance
        uint balance = stakingBalance[msg.sender];

        // Require amount greater than 0
        require(balance > 0, "staking balance cannot be 0");

        // tranfer Mock Dai tokens to this contract for staking
        daiToken.transfer(msg.sender, balance);

        // Reset staking balance
        stakingBalance[msg.sender] = 0;

        // Update staking status
        isStaking[msg.sender] = false;
    }




    // 3. Issuing Tokens (Earning Interest)

    function issueTokens() public {

        // Allow only the owner to issue tokens since this function is public
        require(msg.sender == owner, "caller must be the owner");

        // issue token for all stakers (interset amt)
        for (uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }
}
