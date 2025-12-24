# JungleDAO Governance

Core governance infrastructure for the JungleDAO ecosystem. This repository contains the Anchor-based programs responsible for proposal creation, stake-weighted voting, and trustless execution.

## Overview
The protocol uses a decentralized voting mechanism to manage treasury allocations and parameter adjustments. It is designed to be modular, allowing the DAO to evolve its voting logic without migrating the entire state.

### Key Features
* **Weighted Voting:** Voting power is determined by token/NFT snapshots.
* **Timelocked Execution:** Mandatory cooldown period between a successful vote and instruction execution to protect the community.
* **State Machine:** Proposals transition through `Active -> Passed/Failed -> Executed` to prevent double-spending or replay attacks.

## Getting Started

### Prerequisites
* [Rust](https://www.rust-lang.org/)
* [Solana CLI](https://docs.solana.com/cli/install-solana-cli-tools)
* [Anchor Framework](https://www.anchor-lang.com/)

### Build & Test
1.  **Install dependencies:**
    ```bash
    yarn install
    ```
2.  **Build the program:**
    ```bash
    anchor build
    ```
3.  **Run the local test suite:**
    ```bash
    anchor test
    ```

## Program Architecture
The main logic resides in `programs/jungle-dao-governance/src/lib.rs`. 
* `initialize`: Sets up governance parameters (quorum, delay).
* `vote`: Records user sentiment based on current stake.
* `execute`: Triggers the on-chain instruction once the timelock expires.

## Security
This code is currently in active development. Use at your own risk. For bug reports or security disclosures, please open an issue or contact the core contributors.
<!DOCTYPE html>
<html lang="en">
<head>
<style>
    .sovereign-profile-card {
        max-width: 350px;
        background: #1a1a1a;
        color: #ffffff;
        padding: 25px;
        border-radius: 15px;
        font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        border: 1px solid #333;
        box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        margin: 20px auto;
        text-align: center;
    }

    .sovereign-profile-card h3 {
        margin-top: 0;
        letter-spacing: 2px;
        color: #2980b9;
        font-size: 1.2rem;
        text-transform: uppercase;
        border-bottom: 1px solid #333;
        padding-bottom: 15px;
    }

    .link-container {
        display: flex;
        flex-direction: column;
        gap: 12px;
        margin-top: 20px;
    }

    .profile-link {
        display: block;
        padding: 12px;
        text-decoration: none;
        color: #e0e0e0;
        background: #262626;
        border-radius: 8px;
        transition: all 0.3s ease;
        border: 1px solid transparent;
        font-weight: 500;
        font-size: 0.95rem;
    }

    .profile-link:hover {
        background: #333;
        border-color: #2980b9;
        color: #fff;
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(41, 128, 185, 0.2);
    }

    .profile-link span {
        margin-right: 8px;
        opacity: 0.7;
    }

    .footer-note {
        font-size: 0.7rem;
        color: #555;
        margin-top: 20px;
        letter-spacing: 1px;
    }
</style>
</head>
<body>

<div class="sovereign-profile-card">
    <h3>Sovereign Origin</h3>
    
    <div class="link-container">
        <a href="https://x.com/vccmac?s=21" target="_blank" class="profile-link">
            <span>𝕏</span> X / Twitter
        </a>

        <a href="https://www.facebook.com/share/1JFZFdNNAG/?mibextid=wwXIfr" target="_blank" class="profile-link">
            <span>f</span> Facebook
        </a>

        <a href="https://github.com/cmiller9851-wq" target="_blank" class="profile-link">
            <span>&lt;/&gt;</span> GitHub Repository
        </a>

        <a href="http://swervincurvin.blogspot.com/" target="_blank" class="profile-link">
            <span>✍</span> Original Theory Blog
        </a>
    </div>

    <div class="footer-note">SYSTEM EQUILIBRIUM ENFORCED</div>
</div>

</body>
</html>
