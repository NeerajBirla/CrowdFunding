// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
contract CrowdFunding {


    // step 1 -> create a struct (object in js)
    struct Campaign
    {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    // step 2 mapping 
    mapping(uint256 => Campaign) public campaigns;

    uint256  public numberOfCampaigns = 0;

    function createCampaign(address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        // uint256 _amountCollected,
        string memory _image
        ) public returns(uint256)
        {
            Campaign storage campaign = campaigns[numberOfCampaigns];

            require(campaign.deadline < block.timestamp, "The deadline should be a date in the future."); // to check everything is okay ?

            campaign.owner = _owner;
            campaign.title = _title;
            campaign.description = _description;
            campaign.target = _target;
            campaign.deadline = _deadline;
            campaign.amountCollected = 0;
            campaign.image = _image;

            numberOfCampaigns++;

            return numberOfCampaigns -1 ; // index of most recent created campaign
        }

    function donateToCampaign(uint256 _id) public payable
    {
        uint256 amount = msg.value;  //it is a memeber of the message object to send transaction over ethereum network

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender); // pushing the address of the donator
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent)
        {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns(address[] memory , uint256[] memory)
    {
        return (campaigns[_id].donators , campaigns[_id].donations);
    }

    function getCampaigns() view public returns(Campaign[] memory)
    {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i =0 ; i<numberOfCampaigns;i++)
        {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }
        return allCampaigns;
    }    
   
}