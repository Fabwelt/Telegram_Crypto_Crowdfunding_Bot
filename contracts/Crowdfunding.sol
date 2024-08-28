// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public creator;
    uint public goal;
    uint public deadline;
    uint public amountRaised;
    bool public isActive;

    mapping(address => uint) public contributions;

    event ContributionReceived(address contributor, uint amount);
    event FundsWithdrawn(address recipient, uint amount);
    event RefundIssued(address contributor, uint amount);

    constructor(address _creator, uint _goal, uint _duration) {
        creator = _creator;
        goal = _goal;
        deadline = block.timestamp + _duration;
        isActive = true;
    }

    function contribute() external payable {
        require(isActive, "Campaign is not active");
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Contribution must be greater than 0");

        contributions[msg.sender] += msg.value;
        amountRaised += msg.value;

        emit ContributionReceived(msg.sender, msg.value);
    }

    function withdrawFunds() external {
        require(msg.sender == creator, "Only the creator can withdraw funds");
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        require(amountRaised >= goal, "Goal not reached");

        isActive = false;
        payable(creator).transfer(amountRaised);

        emit FundsWithdrawn(creator, amountRaised);
    }

    function claimRefund() external {
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        require(amountRaised < goal, "Goal was reached, no refunds available");

        uint contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contributedAmount);

        emit RefundIssued(msg.sender, contributedAmount);
    }

    function getDetails() external view returns (address, uint, uint, uint, bool) {
        return (creator, goal, deadline, amountRaised, isActive);
    }
}
