Crowdfunding Contract
Purpose:
The Crowdfunding contract facilitates an individual crowdfunding campaign where users can contribute funds to help reach a goal. The contract supports setting a soft cap (minimum goal) and a hard cap (maximum goal). If the soft cap is reached by the deadline, the campaign creator can withdraw the funds. If the hard cap is reached, the campaign is automatically closed, and no further contributions are allowed. The contract also supports token-based contributions, a referral system for contributors, and additional campaign metadata.

Key Variables:
creator: The address of the campaign creator.
softCap: The minimum amount of funds required for the campaign to be successful.
hardCap: The maximum amount of funds the campaign can raise.
deadline: The timestamp after which the campaign ends.
amountRaised: The total amount of funds raised.
isActive: A boolean indicating whether the campaign is still active.
token: The ERC-20 token used for contributions.
description: A string containing the campaign's description.
website: A string containing the campaign's website URL.
socialMedia: A string containing the campaign's social media links.
contributions: A mapping of contributor addresses to the amount they have contributed.
referrals: A mapping of contributor addresses to their referrer addresses.
referralRewards: A mapping of referrer addresses to their accumulated referral rewards.

Key Functions:
contribute(uint _amount, address _referralAddress)
Allows users to contribute to the campaign by sending ERC-20 tokens to the contract.
Ensures the campaign is active, that the deadline has not passed, and that the contribution does not exceed the hard cap.
Updates the contributor’s balance and the total amountRaised.
If a valid referral address is provided, the referrer earns a reward.
Emits a ContributionReceived event.
If the amountRaised reaches the hardCap, the campaign is automatically closed.
withdrawFunds()
Allows the campaign creator to withdraw the funds if the softCap is met and the deadline has passed.
Ensures only the creator can withdraw, and that the campaign is no longer accepting contributions.
Transfers the funds to the creator and closes the campaign.
Emits a FundsWithdrawn event.
claimRefund()
Allows contributors to claim a refund if the softCap is not met by the deadline.
Ensures the campaign has failed (i.e., amountRaised is less than the softCap).
Refunds the contributor’s balance and updates the contributions mapping.
Emits a RefundIssued event.
withdrawReferralRewards()
Allows users who referred other contributors to withdraw their accumulated referral rewards.
Transfers the rewards to the referrer and resets their reward balance.
Emits an event if needed (e.g., ReferralRewardWithdrawn).
getDetails()
Returns the key details of the campaign, such as the creator's address, soft cap, hard cap, deadline, amount raised, and whether the campaign is active.
updateMetadata(string memory _description, string memory _website, string memory _socialMedia)
Allows the campaign creator to update the campaign's description, website, and social media links.
Only the creator can perform this action.
cancelCampaign()
Allows the campaign creator to cancel the campaign at any time before the deadline.
Marks the campaign as inactive and emits a CampaignCancelled event.
closeCampaign() (internal)
Closes the campaign, marking it as inactive and emitting a CampaignClosed event.

Flow of Operations:
1. Campaign Creation:
When a new Crowdfunding contract is deployed via the factory, it is initialized with a creator, softCap, hardCap, duration, token, and optional metadata (description, website, socialMedia).
The contract sets the deadline based on the provided duration.
2. Contributions:
Users can contribute tokens using the contribute() function, as long as the campaign is active and the hard cap is not reached.
Contributions are tracked in the contributions mapping, and the total amountRaised is updated.
If a valid referral address is provided, the referrer earns a reward based on the contributed amount.
If the hardCap is reached during contributions, the campaign is automatically closed to prevent further contributions.
3. Campaign Conclusion:
If the Soft Cap is Met:
After the deadline, the creator can withdraw the funds using withdrawFunds().
If the Soft Cap is Not Met:
Contributors can claim refunds using claimRefund().
4. Campaign Closure:
A campaign can be closed either automatically when the hard cap is reached or manually when funds are withdrawn after the deadline.
The creator can also manually cancel the campaign before the deadline using cancelCampaign().
5. Referral Rewards:
Contributors who refer others to the campaign can earn referral rewards.
These rewards can be withdrawn separately using the withdrawReferralRewards() function.
6. Metadata Management:
The campaign's description, website, and social media links can be updated by the creator at any time using the updateMetadata() function.
