Crowdfunding Contract
Purpose:
The Crowdfunding contract is an individual crowdfunding campaign where users can contribute funds to help reach a goal. The contract supports setting a soft cap (minimum goal) and a hard cap (maximum goal). If the soft cap is reached by the deadline, the campaign creator can withdraw the funds. If the hard cap is reached, the campaign is automatically closed, and no further contributions are allowed.

Key Variables:
creator: The address of the campaign creator.
softCap: The minimum amount of funds required for the campaign to be successful.
hardCap: The maximum amount of funds the campaign can raise.
deadline: The timestamp after which the campaign ends.
amountRaised: The total amount of funds raised.
isActive: A boolean indicating whether the campaign is still active.
contributions: A mapping of contributor addresses to the amount they have contributed.
Key Functions:
contribute():

Allows users to contribute to the campaign by sending funds to the contract.
Ensures the campaign is active, that the deadline has not passed, and that the contribution does not exceed the hard cap.
Updates the contributor’s balance and the total amountRaised.
Emits a ContributionReceived event.
If the amountRaised reaches the hardCap, the campaign is automatically closed.
withdrawFunds():

Allows the campaign creator to withdraw the funds if the softCap is met and the deadline has passed.
Ensures only the creator can withdraw, and that the campaign is no longer accepting contributions.
Transfers the funds to the creator and closes the campaign.
Emits a FundsWithdrawn event.
claimRefund():

Allows contributors to claim a refund if the softCap is not met by the deadline.
Ensures the campaign has failed (i.e., amountRaised is less than the softCap).
Refunds the contributor’s balance and updates the contributions mapping.
Emits a RefundIssued event.
getDetails():

Returns the key details of the campaign, such as the creator's address, soft cap, hard cap, deadline, amount raised, and whether the campaign is active.
closeCampaign() (internal):

Closes the campaign, marking it as inactive and emitting a CampaignClosed event.
Flow of Operations:
Campaign Creation:

When a new Crowdfunding contract is deployed via the factory, it is initialized with a creator, softCap, hardCap, and duration.
The contract sets the deadline based on the provided duration.
Contributions:

Users can contribute funds using the contribute() function, as long as the campaign is active and the hard cap is not reached.
Contributions are tracked in the contributions mapping, and the total amountRaised is updated.
If the hardCap is reached during contributions, the campaign is automatically closed to prevent further contributions.
Campaign Conclusion:

If the Soft Cap is Met:
After the deadline, the creator can withdraw the funds using withdrawFunds().
If the Soft Cap is Not Met:
Contributors can claim refunds using claimRefund().
Campaign Closure:

A campaign can be closed either automatically when the hard cap is reached or manually when funds are withdrawn after the deadline.
