# 🌳 Jungle DAO Governance Protocol 🐒

A robust, three-contract system for secure, decentralized governance of the EcoCoin token and protocol upgrades.

---

## 💡 Overview

This repository contains all the code required to run the Jungle DAO: the core **Solidity smart contracts** and the **web-based interface** that allows token holders to manage the governance lifecycle.

The architecture is built on the standard, secure OpenZeppelin governance pattern:

1.  **EcoCoin (`ECO`):** An ERC-20 token that supports **delegation** to establish voting power.
2.  **Governor:** Manages the proposal and voting logic.
3.  **Timelock:** The required security mechanism; it holds the administrative authority and introduces a mandatory delay before any approved action can be executed.

## 🚀 Getting Started

Follow these steps to set up the development environment and run the front-end locally.

### Prerequisites

* **Node.js** (v18+) and **npm** or **yarn**
* **Git**
* An Ethereum development framework (e.g., **Hardhat** or **Foundry**) is recommended for testing smart contracts.

### Installation

1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/YourUsername/JungleDAO-Governance.git](https://github.com/YourUsername/JungleDAO-Governance.git)
    cd JungleDAO-Governance
    ```

2.  **Install Dependencies**
    ```bash
    # For the web front-end dependencies (e.g., ethers.js, React, etc.)
    npm install 
    ```

### Usage

1.  **Start the Local Development Server**
    ```bash
    npm run dev
    # The governance interface will typically be available at http://localhost:3000
    ```
2.  **Connect Wallet:** Open the application in your browser and use the **"Connect Wallet"** button (which links to your MetaMask or similar wallet) to begin the delegation and proposal process.

---

## 📂 Repository Structure

The code is organized into two main logical parts:

| Directory | Contents | Description |
| :--- | :--- | :--- |
| `contracts/` | `EcoCoin.sol`, `Governor.sol`, `Timelock.sol` | **The Core Backend.** Contains the Solidity smart contracts that run the DAO on-chain. |
| `src/` | `index.html`, `app.js`, `style.css` | **The Front-End Interface.** Contains the web application code for user interaction. |
| `test/` | `Governor.test.js`, etc. | Unit and integration tests for all smart contracts. |

## 🤝 Contribution

Contributions are welcome! Please follow these steps to contribute:

1.  Fork the repository.
2.  Create a new feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'feat: Add AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

***
_Built for a decentralized future._
