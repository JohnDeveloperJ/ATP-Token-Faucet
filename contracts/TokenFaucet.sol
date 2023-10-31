// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A simple ERC20 token faucet
/// @author John Johnson
/// @notice This contract allows users to claim a fixed amount of tokens after a cooldown period
/// @dev This contract interacts with a standard ERC20 token and uses OpenZeppelin's Ownable contract for ownership management
contract TokenFaucet is Ownable (msg.sender) {
    IERC20 public token;
    uint256 public amountPerClaim;
    uint256 public cooldownPeriod;
    mapping(address => uint256) public lastClaimTime;

    /// @notice Creates a token faucet for a specific ERC20 token
    /// @param tokenAddress The address of the ERC20 token
    /// @param _amountPerClaim The amount of tokens a user can claim per interaction
    /// @param _cooldownPeriod The time a user must wait before claiming tokens again
    constructor(address tokenAddress, uint256 _amountPerClaim, uint256 _cooldownPeriod) {
        token = IERC20(tokenAddress);
        amountPerClaim = _amountPerClaim;
        cooldownPeriod = _cooldownPeriod;
    }

    /// @notice Allows a user to claim a predefined amount of tokens, if cooldown period has passed
    /// @dev Requires the cooldown period since the last claim to have passed for the msg sender
    function claimTokens() public {
        require(block.timestamp - lastClaimTime[msg.sender] > cooldownPeriod, "Cooldown period has not passed");
        
        lastClaimTime[msg.sender] = block.timestamp;
        require(token.transfer(msg.sender, amountPerClaim), "Token transfer failed");
    }

    /// @notice Supplies the faucet with a certain amount of tokens
    /// @dev Only callable by the owner of the contract
    /// @param amount The amount of tokens to be added to the faucet
    function supplyFaucet(uint256 amount) public onlyOwner {
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer to faucet failed");
    }

    /// @notice Allows the owner to withdraw tokens from the faucet
    /// @dev Only callable by the owner of the contract
    /// @param amount The amount of tokens to be withdrawn
    function withdrawTokens(uint256 amount) public onlyOwner {
        require(token.transfer(msg.sender, amount), "Withdraw failed");
    }

    // Additional functions for managing amountPerClaim, cooldownPeriod, etc., could be added here
}
