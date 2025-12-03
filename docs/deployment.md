# Deployment Guide

### Prerequisites
- Node.js ≥ 20
- Docker (optional, for containerized deployment)
- Access to the target blockchain network (e.g., Infura API key for Ethereum)

### Local Development
```bash
git clone https://github.com/your-org/jungle-dao.git
cd jungle-dao
npm install
npm run dev
Production (Docker)

Build the image:
bash
Copy Code
docker build -t jungle-dao:latest .
Run the container:
bash
Copy Code
docker run -d -p 3000:3000 \
  -e NODE_ENV=production \
  -e BLOCKCHAIN_RPC_URL=https://mainnet.infura.io/v3/YOUR_KEY \
  jungle-dao:latest
Environment Variables

VARIABLE	DESCRIPTION
BLOCKCHAIN_RPC_URL	RPC endpoint for the target chain
PORT	Port the service listens on (default 3000)
JWT_SECRET	Secret for API authentication (optional)
 After deployment, the API is reachable at http://<host>:<port>/. 
