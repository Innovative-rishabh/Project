// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CrowdfundingPlatform {
    address public creator;
    uint256 public goal;
    uint256 public deadline;
    uint256 public totalRaised;
    bool public goalReached;
    bool public fundsWithdrawn;

    mapping(address => uint256) public contributions;

    constructor(uint256 _goalInWei, uint256 _durationInSeconds) {
        creator = msg.sender;
        goal = _goalInWei;
        deadline = block.timestamp + _durationInSeconds;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Only creator can perform this action");
        _;
    }

    modifier beforeDeadline() {
        require(block.timestamp < deadline, "Deadline has passed");
        _;
    }

    modifier afterDeadline() {
        require(block.timestamp >= deadline, "Deadline not yet reached");
        _;
    }

    function contribute() external payable beforeDeadline {
        require(msg.value > 0, "Contribution must be greater than 0");
        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;

        if (totalRaised >= goal) {
            goalReached = true;
        }
    }

    function withdrawFunds() external onlyCreator afterDeadline {
        require(goalReached, "Goal not reached");
        require(!fundsWithdrawn, "Funds already withdrawn");

        fundsWithdrawn = true;
        payable(creator).transfer(totalRaised);
    }

    function refund() external afterDeadline {
        require(!goalReached, "Goal was reached");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No funds to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
