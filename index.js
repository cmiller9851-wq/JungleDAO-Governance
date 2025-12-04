// Jungle DAO – basic entry point
// This file demonstrates a simple proposal‑voting flow.

class Proposal {
  constructor(id, description, execute) {
    this.id = id;
    this.description = description;
    this.execute = execute; // function to run when proposal passes
    this.votesFor = 0;
    this.votesAgainst = 0;
    this.closed = false;
  }

  vote(weight, support) {
    if (this.closed) throw new Error('Proposal is closed');
    if (support) this.votesFor += weight;
    else this.votesAgainst += weight;
  }

  // Simple majority quorum (can be replaced with more complex logic)
  isPassed(quorum = 1) {
    const total = this.votesFor + this.votesAgainst;
    return total >= quorum && this.votesFor > this.votesAgainst;
  }

  finalize() {
    if (this.closed) return;
    this.closed = true;
    if (this.isPassed()) {
      console.log(`Proposal ${this.id} passed – executing...`);
      this.execute();
    } else {
      console.log(`Proposal ${this.id} failed.`);
    }
  }
}

// Example usage
const demoProposal = new Proposal(
  1,
  'Transfer 100 tokens to treasury',
  () => console.log('🪙 Treasury funded!')
);

// Simulate voting (weights could be token balances)
demoProposal.vote(3, true);   // 3 votes for
demoProposal.vote(1, false); // 1 vote against

// Close voting and act
demoProposal.finalize();

// Export for external modules
module.exports = { Proposal };
