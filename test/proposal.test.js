const assert = require('assert');
const { Proposal } = require('../index');

// Helper to create a proposal with a no‑op execute function
const createProposal = (id, desc) =>
  new Proposal(id, desc, () => { /* no‑op */ });

// Test: proposal passes with majority votes
const p1 = createProposal(1, 'Simple majority');
p1.vote(5, true);   // 5 for
p1.vote(2, false);  // 2 against
p1.finalize();
assert.strictEqual(p1.closed, true, 'Proposal should be closed');
assert.strictEqual(p1.isPassed(), true, 'Proposal should pass');

// Test: proposal fails when against votes are equal or greater
const p2 = createProposal(2, 'Fails on tie');
p2.vote(3, true);
p2.vote(3, false);
p2.finalize();
assert.strictEqual(p2.isPassed(), false, 'Proposal should fail on tie');

console.log('All proposal tests passed.');
