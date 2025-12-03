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
