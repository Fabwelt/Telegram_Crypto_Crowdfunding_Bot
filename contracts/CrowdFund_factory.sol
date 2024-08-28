// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Crowdfunding.sol";

contract CrowdfundingFactory {
    Crowdfunding[] public campaigns;

    event CampaignCreated(address campaignAddress, address creator, uint goal, uint duration);

    function createCampaign(uint _goal, uint _duration) external {
        Crowdfunding newCampaign = new Crowdfunding(msg.sender, _goal, _duration);
        campaigns.push(newCampaign);

        emit CampaignCreated(address(newCampaign), msg.sender, _goal, _duration);
    }

    function getCampaigns() external view returns (Crowdfunding[] memory) {
        return campaigns;
    }
}
