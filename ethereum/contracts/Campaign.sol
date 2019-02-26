pragma solidity ^0.4.25;

contract CompaignFactory{
    address[] public deployedCampaigns;
    function createCampaign(uint _minimum) public{
         address NewCampaign = address (new Campaign(_minimum, msg.sender));
         deployedCampaigns.push(NewCampaign);
    }
    function getDeployedCampaigns() public view returns (address[] memory){
        return deployedCampaigns;
    }
}

contract Campaign{
    struct Request{
        string description;
        uint value;
        address  recepient;
        bool complete;
        uint approvalCount;
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    mapping (address => bool) public approvers;
    uint approversCount;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    constructor(uint _minimum, address _addr) public {
        manager = _addr;
        minimumContribution = _minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        approversCount ++;
        approvers[msg.sender] = true;
    }
    
    function createRequest(string memory _description, uint _value, address  _recepient) 
        public restricted {
            Request memory newRequest = Request({
                description: _description,
                value: _value,
                recepient: _recepient,
                complete: false,
                approvalCount: 0
            });
            
            requests.push(newRequest);
    }
    
    function approveRequest(uint _index) public {
        Request storage request = requests[_index];
        
        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);
        
        request.approvals[msg.sender] = true;
        request.approvalCount ++;
    }
    function finalizeRequest(uint _index) public restricted{
        Request storage request = requests[_index];
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        
        request.recepient.transfer(request.value);
        request.complete =true;
    }

    function getSummary() public view returns(
        uint, uint, uint, uint, address
        ) {
        return(
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
    
}