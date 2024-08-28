// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Crowdfunding is ReentrancyGuard {
    address public creator;
    uint public softCap;
    uint public hardCap;
    uint public deadline;
    uint public amountRaised;
    bool public isActive;
    IERC20 public token;  // ERC-20 token for contributions

    string public description;
    string public website;
    string public socialMedia;

    mapping(address => uint) public contributions;
    mapping(address => address) public referrals;  // Maps contributor to referrer
    mapping(address => uint) public referralRewards;

    event ContributionReceived(address indexed contributor, uint amount);
    event FundsWithdrawn(address indexed recipient, uint amount);
    event RefundIssued(address indexed contributor, uint amount);
    event CampaignClosed(address indexed campaignAddress, bool successful);
    event CampaignCancelled(address indexed campaignAddress);
    event RewardTierAdded(uint minContribution, string rewardDescription);

    modifier onlyCreator() {
        require(msg.sender == creator, "Only the creator can perform this action");
        _;
    }

    constructor(
        address _creator,
        uint _softCap,
        uint _hardCap,
        uint _duration,
        address _token,
        string memory _description,
        string memory _website,
        string memory _socialMedia
    ) {
        creator = _creator;
        softCap = _softCap;
        hardCap = _hardCap;
        deadline = block.timestamp + _duration;
        token = IERC20(_token);
        description = _description;
        website = _website;
        socialMedia = _socialMedia;
        isActive = true;
    }

    // Contribution with referral system
    function contribute(uint _amount, address _referralAddress) external nonReentrant {
        require(isActive, "Campaign is not active");
        require(block.timestamp < deadline, "Campaign has ended");
        require(_amount > 0, "Contribution must be greater than 0");
        require(amountRaised + _amount <= hardCap, "Contribution exceeds hard cap");

        token.transferFrom(msg.sender, address(this), _amount);
        contributions[msg.sender] += _amount;
        amountRaised += _amount;

        emit ContributionReceived(msg.sender, _amount);

        // Handle referral
        if (_referralAddress != address(0) && _referralAddress != msg.sender) {
            referrals[msg.sender] = _referralAddress;
            uint reward = (_amount * 5) / 100;  // 5% referral reward
            referralRewards[_referralAddress] += reward;
        }

        if (amountRaised >= hardCap) {
            closeCampaign();
        }
    }

    // Allow the creator to cancel the campaign
    function cancelCampaign() external onlyCreator {
        require(isActive, "Campaign is already inactive");
        closeCampaign();
        emit CampaignCancelled(address(this));
    }

    // Withdraw the raised funds if the soft cap is met and the deadline has passed
    function withdrawFunds() external nonReentrant onlyCreator {
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        require(amountRaised >= softCap, "Soft cap not reached, cannot withdraw");

        closeCampaign();
        token.transfer(creator, amountRaised);

        emit FundsWithdrawn(creator, amountRaised);
    }

    // Contributors can claim a refund if the soft cap is not met
    function claimRefund() external nonReentrant {
        require(block.timestamp >= deadline, "Campaign is still ongoing");
        require(amountRaised < softCap, "Soft cap was reached, no refunds available");

        uint contributedAmount = contributions[msg.sender];
        require(contributedAmount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        token.transfer(msg.sender, contributedAmount);

        emit RefundIssued(msg.sender, contributedAmount);
    }

    // Withdraw referral rewards
    function withdrawReferralRewards() external nonReentrant {
        uint reward = referralRewards[msg.sender];
        require(reward > 0, "No rewards available");
        referralRewards[msg.sender] = 0;
        token.transfer(msg.sender, reward);
    }

    // Function to update metadata if necessary
    function updateMetadata(string memory _description, string memory _website, string memory _socialMedia) external onlyCreator {
        description = _description;
        website = _website;
        socialMedia = _socialMedia;
    }

    // Get campaign details
    function getDetails() external view returns (address, uint, uint, uint, uint, bool) {
        return (creator, softCap, hardCap, deadline, amountRaised, isActive);
    }

    // Internal function to close the campaign
    function closeCampaign() internal {
        isActive = false;
        emit CampaignClosed(address(this), amountRaised >= softCap);
    }

    // View time left before the campaign ends
    function timeLeft() external view returns (uint) {
        if (block.timestamp >= deadline) {
            return 0;
        }
        return deadline - block.timestamp;
    }

    // Check if the campaign was successful
    function isCampaignSuccessful() external view returns (bool) {
        return amountRaised >= softCap;
    }
}
