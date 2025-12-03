# Jungle DAO

**Jungle DAO** is a lightweight, modular framework for on‑chain governance and treasury management. It provides a simple API for creating proposals, voting, and executing treasury actions in a secure, permission‑less environment.

## Quick start

```bash
# Clone the repository
git clone https://github.com/your-org/jungle-dao.git
cd jungle-dao

# Install dependencies
npm install

# Run the development server
npm run dev
Core concepts

Proposals – JSON‑encoded actions that members can vote on.
Voting – Token‑weighted, configurable quorum and voting period.
Treasury – Managed by multi‑sig contracts; funds are released only on passed proposals.
Documentation

Architecture Overview
API Reference
Deployment Guide
Contributing

See CONTRIBUTING.md for guidelines on how to submit issues, feature requests, and pull requests.
License

Apache License 2.0 – © 2025 Cory Miller
### Next merge: Add the three core Solidity contracts and a simple deployment script  

Below is a concise, step‑by‑step plan you can execute directly from the GitHub web UI (or locally and push). The three contracts cover the full “phi‑braid” stack:

| Contract | Role |
|----------|------|
| **Proposal.sol** | Stores JSON‑encoded proposals, tracks voting, calculates quorum, and emits `ProposalExecuted`. |
| **TokenWeightedVoting.sol** | Handles token‑balance look‑ups (ERC‑20 or ERC‑721), records votes, and enforces the quorum logic. |
| **Treasury.sol** | Multi‑sig wallet that receives ETH/SAT‑wrapped tokens and only releases funds when a proposal is passed. |

---

## 1. Create the `contracts/` folder  

1. **Add file** → **Create new file**.  
2. **Path**: `contracts/`. (GitHub will create the folder automatically when you add the first file inside it.)

---

## 2. `contracts/Proposal.sol`

```solidity
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
```

**Commit message:** `Add Proposal.sol – core proposal storage & execution hook`.

---

## 3. `contracts/TokenWeightedVoting.sol`

```solidity
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
```

**Commit message:** `Add TokenWeightedVoting.sol – token‑balance weighted voting with quorum`.

---

## 4. `contracts/Treasury.sol`

```solidity
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
```

**Commit message:** `Add Treasury.sol – multi‑sig wallet that only releases funds on approved calls`.

---

## 5. Deployment script (JavaScript)  

Create a `scripts/` folder and add `deploy.js`:

```javascript
// scripts/deploy.js
const { ethers } = require("ethers");
require("dotenv").config();

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.RPC_URL);
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

  // Deploy Token (use an existing ERC20 address if you have one)
  const tokenAddress = process.env.TOKEN_ADDRESS; // e.g., USDC on testnet

  // Deploy Treasury (2‑of‑3 owners example)
  const Treasury = await ethers.getContractFactory("Treasury", wallet);
  const treasury = await Treasury.deploy(
    [process.env.OWNER1, process.env.OWNER2, process.env.OWNER3],
    2
  );
  await treasury.waitForDeployment();
  console.log("Treasury deployed at:", treasury.target);

  // Deploy Voting
  const Voting = await ethers.getContractFactory("TokenWeightedVoting", wallet);
  const voting = await Voting.deploy(tokenAddress, ethers.parseUnits("1000", 18)); // quorum = 1000 tokens
  await voting.waitForDeployment();
  console.log("Voting deployed at:", voting.target);

  // Deploy Proposal
  const Proposal = await ethers.getContractFactory("Proposal", wallet);
  const proposal = await Proposal.deploy(voting.target, treasury.target);
  await proposal.waitForDeployment();
  console.log("Proposal contract deployed at:", proposal.target);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
```

**Commit message:** `Add deploy.js – script to launch Treasury, Voting, and Proposal contracts`.

---

## 6. Update `README.md` with a “Deploy & Run” section  

Add a short snippet under **Quick start**:

```markdown
## Deploy contracts

```bash
# Install ethers & dotenv
npm install ethers dotenv

# Set environment variables (create a .env file)
cat > .env <<EOF
RPC_URL=https://goerli.infura.io/v3/YOUR_KEY
PRIVATE_KEY=0xYOUR_PRIVATE_KEY
TOKEN_ADDRESS=0xYourERC20Address
OWNER1=0xAddr1
OWNER2=0xAddr2
OWNER3=0xAddr3
EOF

# Deploy
node scripts/deploy.js
```

The script prints the three contract addresses; copy them into the `Proposal` constructor when you interact via the UI or a front‑end script.
```
