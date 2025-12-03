// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

import "./TokenWeightedVoting.sol";
import "./Treasury.sol";

contract Proposal {
    struct Data {
        uint256 id;
        string json;          // JSON‑encoded proposal payload
        uint256 start;        // block timestamp when voting opens
        uint256 end;          // block timestamp when voting closes
        bool executed;
    }

    uint256 public nextId;
    mapping(uint256 => Data) public proposals;
    TokenWeightedVoting public voting;
    Treasury public treasury;

    event ProposalCreated(uint256 indexed id, string json);
    event ProposalExecuted(uint256 indexed id, bool passed);

    constructor(address _voting, address _treasury) {
        voting = TokenWeightedVoting(_voting);
        treasury = Treasury(_treasury);
    }

    function create(string calldata json, uint256 votingPeriod) external {
        uint256 id = nextId++;
        proposals[id] = Data({
            id: id,
            json: json,
            start: block.timestamp,
            end: block.timestamp + votingPeriod,
            executed: false
        });
        emit ProposalCreated(id, json);
    }

    function execute(uint256 id) external {
        Data storage p = proposals[id];
        require(block.timestamp > p.end, "Voting still open");
        require(!p.executed, "Already executed");

        bool passed = voting.isPassed(id);
        if (passed) {
            // Decode the JSON payload off‑chain and call treasury accordingly.
            // For demo we just forward any ETH held by this contract.
            treasury.releaseFunds(address(this).balance);
        }
        p.executed = true;
        emit ProposalExecuted(id, passed);
    }
}
