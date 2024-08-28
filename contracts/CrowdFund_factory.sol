// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Crowdfunding.sol";

contract CrowdfundingFactory {
    Crowdfunding[] public campaigns;

    event CampaignCreated(
        address indexed campaignAddress,
        address indexed creator,
        uint softCap,
        uint hardCap,
        uint duration,
        address token,
        string description,
        string website,
        string socialMedia
    );

    // Function to create a new campaign
    function createCampaign(
        uint _softCap,
        uint _hardCap,
        uint _duration,
        address _token,
        string memory _description,
        string memory _website,
        string memory _socialMedia
    ) external {
        require(_softCap > 0, "Soft cap must be greater than 0");
        require(_hardCap > _softCap, "Hard cap must be greater than soft cap");
        require(_token != address(0), "Token address must be valid");

        Crowdfunding newCampaign = new Crowdfunding(
            msg.sender,
            _softCap,
            _hardCap,
            _duration,
            _token,
            _description,
            _website,
            _socialMedia
        );

        campaigns.push(newCampaign);

        emit CampaignCreated(
            address(newCampaign),
            msg.sender,
            _softCap,
            _hardCap,
            _duration,
            _token,
            _description,
            _website,
            _socialMedia
        );
    }

    // Function to get the list of all campaigns
    function getCampaigns() external view returns (Crowdfunding[] memory) {
        return campaigns;
    }
}
