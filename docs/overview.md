# Overview

This project implements a small token accounting system for a smart-contract challenge. The token behaves like an ETH-backed ERC20-style asset with an additional dividend mechanism.

## Problem

Dividend-paying tokens need to answer two questions:

- Who currently holds tokens when a dividend is recorded?
- How much can each address withdraw later, even if ownership changes after the dividend event?

This implementation solves the problem directly with holder tracking and per-address withdrawable dividend balances.

## Users

- Smart-contract reviewers evaluating implementation tradeoffs.
- Developers studying ERC20-style accounting.
- Interviewers or candidates using tests to validate correctness.

## Scope

In scope:

- Mint, burn, transfer, allowance, and transfer-from behavior.
- Holder list maintenance.
- Proportional dividend recording.
- Dividend withdrawals after balance changes.

Out of scope:

- Production token launch.
- Upgradeability.
- Gas-optimized dividend indexing for large holder sets.
- Formal verification or third-party audit.

## Outcome

The repository demonstrates a complete tested solution for a constrained dividend-token challenge.
