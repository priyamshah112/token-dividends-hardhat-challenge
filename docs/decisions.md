# Decisions

## Holder tracking with array plus index mapping

The contract maintains an array of current holders and a 1-based index mapping. This enables O(1) insertion and swap-and-pop removal when balances move to or from zero.

## Dividend balance is stored separately from token balance

Accrued dividend payouts are stored in `_withdrawableDividend`. This preserves a user's right to withdraw dividends that were earned before later transfers or burns.

## Checks-effects-interactions for withdrawals

Dividend withdrawal resets the ledger before sending ETH. This follows the checks-effects-interactions pattern and reduces re-entrancy risk in the withdrawal flow.

## Direct proportional payout calculation

`recordDividend()` calculates each holder's share at the time the dividend is recorded. The approach is simple and testable, but it scales linearly with the number of holders.
