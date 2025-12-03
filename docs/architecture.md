# Architecture Overview

Jungle DAO consists of three main layers:

1. **Core Engine** – Handles proposal creation, voting, and result calculation.
2. **Treasury Module** – Manages multi‑sig wallets and fund releases.
3. **Adapter Layer** – Connects the core engine to various blockchain runtimes
   (e.g., Ethereum, Solana, Cosmos).

## Data Flow

1. A user submits a proposal via the API.  
2. The Core Engine stores the proposal and opens a voting window.  
3. Votes are recorded with token‑weighted power.  
4. After the voting period, the engine evaluates the result.  
5. If passed, the Treasury Module executes the attached action through the
   appropriate blockchain adapter.

## Extensibility

- New voting mechanisms (quadratic, conviction) can be added as plugins.  
- Additional treasury back‑ends (e.g., Gnosis Safe, Aragon) are supported via
  the Adapter Layer.
