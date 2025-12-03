# API Reference

## Proposal API

- `POST /proposals` – Create a new proposal.  
  **Body**: `{ description: string, execute: string }`

- `GET /proposals/:id` – Retrieve proposal details.

- `POST /proposals/:id/vote` – Cast a vote.  
  **Body**: `{ weight: number, support: boolean }`

## Treasury API

- `POST /treasury/execute` – Execute an approved proposal action.  
  **Body**: `{ proposalId: number }`

## WebSocket Events

- `proposalCreated` – Emitted when a new proposal is opened.  
- `voteCast` – Emitted after each vote.  
- `proposalFinalized` – Emitted when voting ends and the result is known.
