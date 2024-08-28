// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard {
    address public creator;
    uint public softCap;
    uint public hardCap;
    uint public deadline;
    uint public amountRaised;
    bool public isActive;

    mapping(address => uint) public contributions;

    event ContributionReceived(address indexed contributor, uint amount);
    event FundsWithdrawn(address indexed recipient, uint amount);
    event RefundIssued(address indexed contributor, uint amount);
    event CampaignClosed(address indexed campaignAddress, bool successful);

    constructor(address _creator, uint _softCap, uint _hardCap, uint _duration) {
        creator = _creator;
        softCap = _softCap;
        hardCap = _hardCap;
        deadline = block.timestamp + _duration;
        isActive = true;
    }

    function contribute() external payable nonReentrant {
        require(isActive, "Campaign is not active");
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than 0");
        require(amountRaised + msg.value <= hardCap, "Contribution exceeds hard cap");

        contributions[msg.sender] += msg.value;
        amountRaised += msg.value;

        emit ContributionReceived(msg.sender, msg.value);

        if (amountRaised >= hardCap) {
            closeCampaign();
        }
    }

    function withdrawFunds() external nonReentrant {
        require(msg.sender == creator, "Only the creator can withdraw funds");
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        require(amountRaised >= softCap, "Soft cap not reached, cannot withdraw");

        closeCampaign();
        payable(creator).transfer(amountRaised);

        emit FundsWithdrawn(creator, amountRaised);
    }

    function claimRefund() external nonReentrant {
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        require(amountRaised < softCap, "Soft cap was reached, no refunds available");

        uint contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributedAmount);

        emit RefundIssued(msg.sender, contributedAmount);
    }

    function getDetails() external view returns (address, uint, uint, uint, uint, bool) {
        return (creator, softCap, hardCap, deadline, amountRaised, isActive);
    }

    function closeCampaign() internal {
        isActive = false;
        emit CampaignClosed(address(this), amountRaised >= softCap);
    }

    function timeLeft() external view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }

    function isCampaignSuccessful() external view returns (bool) {
        return amountRaised >= softCap;
    }
}
