use anchor_lang::prelude::*;
use anchor_lang::solana_program::instruction::Instruction;
use anchor_lang::solana_program::program::invoke_signed;

declare_id!("Your_Program_ID_Here"); // Ensure this matches your Anchor.toml

#[program]
pub mod jungle_dao_governance {
    use super::*;

    // ... existing initialize and vote functions ...

    pub fn execute_proposal(ctx: Context<ExecuteProposal>) -> Result<()> {
        let proposal = &mut ctx.accounts.proposal;
        let clock = Clock::get()?;

        // 1. Validation: Is it time?
        require!(
            proposal.status == ProposalStatus::Passed,
            GovernanceError::InvalidStatus
        );
        require!(
            clock.unix_timestamp >= proposal.end_time + proposal.execution_delay,
            GovernanceError::TimelockNotExpired
        );

        // 2. Logic to execute a generic instruction
        // In a real-world beefed up version, we'd use the stored instruction data
        // For this commit, we transition the state to prevent double-execution
        proposal.status = ProposalStatus::Executed;

        msg!("Proposal {} has been successfully executed.", proposal.key());
        Ok(())
    }
}

#[derive(Accounts)]
pub struct ExecuteProposal<'info> {
    #[account(mut)]
    pub proposal: Account<'info, Proposal>,
    pub executor: Signer<'info>,
}

#[account]
pub struct Proposal {
    pub creator: Pubkey,
    pub votes_for: u64,
    pub votes_against: u64,
    pub end_time: i64,
    pub execution_delay: i64,
    pub status: ProposalStatus,
}

#[derive(AnchorSerialize, AnchorDeserialize, Clone, PartialEq, Eq)]
pub enum ProposalStatus {
    Active,
    Passed,
    Failed,
    Executed,
}

#[error_code]
pub enum GovernanceError {
    #[msg("The voting period has not ended yet.")]
    VotingNotEnded,
    #[msg("The timelock period has not expired.")]
    TimelockNotExpired,
    #[msg("This proposal is not in a valid state for execution.")]
    InvalidStatus,
}
