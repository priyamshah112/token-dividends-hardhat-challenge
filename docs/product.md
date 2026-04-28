# Product

## Product Goal

Implement a token challenge where ETH-backed token holders can receive and later withdraw proportional dividend payouts.

## Requirements

- Users can mint tokens by depositing ETH.
- Users can burn their full balance and recover backing ETH.
- Users can transfer tokens directly.
- Users can approve and execute delegated transfers.
- The contract can record dividend ETH and assign it to current holders.
- A holder can withdraw dividends even after later transferring or burning tokens.

## User Journeys

### Mint and hold

1. User calls `mint()` with ETH.
2. Contract increases token balance and total supply.
3. Address enters the holder list.

### Record dividends

1. Dividend payer calls `recordDividend()` with ETH.
2. Contract iterates current holders.
3. Contract assigns each holder a proportional withdrawable amount.

### Withdraw after ownership changes

1. Holder earns a dividend.
2. Holder transfers or burns tokens.
3. Holder still withdraws the previously accrued dividend.

## Constraints

- Dividend distribution loops over holders.
- The implementation is challenge-focused rather than production-grade.
- The contract assumes tests define the expected behavior.

## Roadmap Ideas

- Replace direct holder iteration with a cumulative dividend-per-share model.
- Add events for mint, burn, dividend recorded, and dividend withdrawn.
- Add fuzz tests and invariant tests.
- Compare against audited ERC20 and dividend-token patterns.
