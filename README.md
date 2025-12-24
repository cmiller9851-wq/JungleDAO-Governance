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

