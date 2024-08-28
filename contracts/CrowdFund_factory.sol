// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Crowdfunding.sol";

contract CrowdfundingFactory {
    Crowdfunding[] public campaigns;

    event CampaignCreated(address indexed campaignAddress, address indexed creator, uint softCap, uint hardCap, uint duration);

    function createCampaign(uint _softCap, uint _hardCap, uint _duration) external {
        require(_softCap > 0, "Soft cap must be greater than 0");
        require(_hardCap > _softCap, "Hard cap must be greater than soft cap");

        Crowdfunding newCampaign = new Crowdfunding(msg.sender, _softCap, _hardCap, _duration);
        campaigns.push(newCampaign);

        emit CampaignCreated(address(newCampaign), msg.sender, _softCap, _hardCap, _duration);
    }

    function getCampaigns() external view returns (Crowdfunding[] memory) {
        return campaigns;
    }
}
