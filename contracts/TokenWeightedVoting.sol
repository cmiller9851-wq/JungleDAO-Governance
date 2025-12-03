// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

interface IERC20 {
    function balanceOf(address) external view returns (uint256);
}

contract TokenWeightedVoting {
    IERC20 public token;
    uint256 public quorum; // minimum total weight required

    struct Vote {
        uint256 weight;
        bool support;
    }

    // proposalId => voter => Vote
    mapping(uint256 => mapping(address => Vote)) public votes;
    mapping(uint256 => uint256) public totalFor;
    mapping(uint256 => uint256) public totalAgainst;

    event Voted(uint256 indexed proposalId, address indexed voter, uint256 weight, bool support);

    constructor(address tokenAddress, uint256 _quorum) {
        token = IERC20(tokenAddress);
        quorum = _quorum;
    }

    function castVote(uint256 proposalId, bool support) external {
        uint256 weight = token.balanceOf(msg.sender);
        require(weight > 0, "No voting power");

        Vote storage existing = votes[proposalId][msg.sender];
        require(existing.weight == 0, "Already voted");

        votes[proposalId][msg.sender] = Vote({weight: weight, support: support});

        if (support) {
            totalFor[proposalId] += weight;
        } else {
            totalAgainst[proposalId] += weight;
        }

        emit Voted(proposalId, msg.sender, weight, support);
    }

    function isPassed(uint256 proposalId) public view returns (bool) {
        uint256 totalWeight = totalFor[proposalId] + totalAgainst[proposalId];
        if (totalWeight < quorum) return false;
        return totalFor[proposalId] > totalAgainst[proposalId];
    }
}
