# Jungle DAO

**Jungle DAO** is a lightweight, modular framework for on‑chain governance and treasury management. It provides a simple API for creating proposals, voting, and executing treasury actions in a secure, permission‑less environment.

## Quick start

```bash
# Clone the repository
git clone https://github.com/cmiller9851-wq/JungleDAO-Governance.git
cd JungleDAO-Governance

# Install dependencies
npm install

# Run the development server
npm run dev
```

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

The script prints the three contract addresses; copy them into the `Proposal` constructor when interacting via the UI or a front‑end script.

## Core concepts

- **Proposals** – JSON‑encoded actions that members can vote on.  
- **Voting** – Token‑weighted, configurable quorum and voting period.  
- **Treasury** – Managed by a multi‑sig wallet; funds are released only on passed proposals.

## Documentation

- [Architecture Overview](docs/architecture.md)  
- [API Reference](docs/api.md)  
- [Deployment Guide](docs/deployment.md)

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for guidelines on how to submit issues, feature requests, and pull requests.

## License

Apache License 2.0 – © 2025 Cory Miller  
