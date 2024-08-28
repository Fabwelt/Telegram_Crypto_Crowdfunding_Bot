CrowdfundingFactory Contract

Purpose:
The CrowdfundingFactory contract serves as a factory for deploying instances of the Crowdfunding contract. It allows any user to create a new crowdfunding campaign with a specified soft cap, hard cap, and duration. The factory keeps track of all deployed campaigns.

Key Functions:
createCampaign(uint _softCap, uint _hardCap, uint _duration):

Deploys a new instance of the Crowdfunding contract.
Accepts parameters for the soft cap, hard cap, and campaign duration.
Adds the new campaign to an array of Crowdfunding contracts (campaigns).
Emits a CampaignCreated event, logging the campaign's address, creator, soft cap, hard cap, and duration.
getCampaigns():

Returns the list of all deployed crowdfunding campaigns.
Flow of Operations:
Deployment:

The CrowdfundingFactory contract is deployed to the blockchain.
This contract acts as the central hub for creating and managing multiple crowdfunding campaigns.

Creating a Campaign:

A user calls the createCampaign function, providing the desired soft cap, hard cap, and duration for the campaign.
The contract checks that the soft cap is greater than 0 and that the hard cap is greater than the soft cap.
If the checks pass, a new Crowdfunding contract is deployed using the provided parameters.
The address of the new campaign is stored in the campaigns array.
Tracking Campaigns:

The factory contract maintains a record of all created campaigns in the campaigns array.
Users can retrieve this list by calling the getCampaigns function.
