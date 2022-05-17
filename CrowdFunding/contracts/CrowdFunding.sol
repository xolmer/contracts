// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract CrowdFunding {
    mapping(address => uint256) public contributors;
    address public admin;
    uint256 public noOfContributors;
    uint256 public minimumContribution;
    uint256 public deadline;
    uint256 public goal;
    uint256 public raisedAmount;

    struct Request {
        string description;
        address payable recipient;
        uint256 value;
        bool completed;
        uint256 noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint256 => Request) public requests;
    uint256 public numRequests;

    constructor(uint256 _goal, uint256 _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    event ContributeEvent(address _sender, uint256 _value);
    event CreateRequestEvent(
        string _description,
        address _recipient,
        uint256 _value
    );
    event MakePaymentEvent(address _recipient, uint256 _value);

    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline time is over");
        require(
            msg.value >= minimumContribution,
            "Contribution is less than minimum"
        );
        if (contributors[msg.sender] == 0) {
            noOfContributors++;
        }
        contributors[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(msg.sender, msg.value);
    }

    receive() external payable {
        contribute();
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getRefund() public {
        require(
            block.timestamp > deadline && raisedAmount < goal,
            "Refund is not possible"
        );
        require(contributors[msg.sender] > 0, "You have not contributed");

        address payable recipient = payable(msg.sender);
        uint256 value = contributors[msg.sender];
        recipient.transfer(value);
        contributors[msg.sender] = 0;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    function createRequest(
        string memory _description,
        address payable _recipient,
        uint256 _value
    ) public onlyAdmin {
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    function voteRequest(uint256 _requestNo) public {
        require(contributors[msg.sender] > 0, "You have not contributed");
        Request storage thisRequest = requests[_requestNo];

        require(
            thisRequest.voters[msg.sender] == false,
            "You have already voted"
        );
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint256 _requestNo) public onlyAdmin {
        require(raisedAmount >= goal, "Funding goal not reached");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed == false, "Request already completed");
        require(
            thisRequest.noOfVoters > noOfContributors / 2,
            "Not enough votes"
        );

        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
}
