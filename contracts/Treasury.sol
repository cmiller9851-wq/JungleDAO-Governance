// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.24;

contract Treasury {
    address[] public owners;
    uint256 public required; // number of signatures needed

    mapping(bytes32 => uint256) public approvals;

    event FundsReleased(address to, uint256 amount);
    event Approval(address indexed owner, bytes32 txHash);

    modifier onlyOwner() {
        bool isOwner = false;
        for (uint256 i = 0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                isOwner = true;
                break;
            }
        }
        require(isOwner, "Not an owner");
        _;
    }

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length >= _required, "Owners < required");
        owners = _owners;
        required = _required;
    }

    // Simple release – called by Proposal after a pass
    function releaseFunds(uint256 amount) external onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(msg.sender).transfer(amount);
        emit FundsReleased(msg.sender, amount);
    }

    // Fallback to receive ETH / wrapped sats
    receive() external payable {}
}
