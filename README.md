# Token Dividends Hardhat Challenge

This repository contains a Solidity and Hardhat implementation of an ETH-backed ERC20-style token with holder-based dividend accounting.

Users mint tokens by depositing ETH, burn tokens to redeem ETH, transfer balances, approve allowances, record ETH dividends, and withdraw accrued dividend payouts.

## Status

Technical assessment / smart-contract prototype.

The implementation is designed to satisfy the included tests and demonstrate contract design tradeoffs. It is not audited and should not be deployed with real value without a full security review.

## Features

- Mint tokens by sending ETH.
- Burn a full token balance and withdraw backing ETH to a destination address.
- Transfer tokens directly or through allowances.
- Track current token holders with an array and 1-based index mapping.
- Record ETH dividends proportionally across current holders.
- Preserve accrued dividends after a holder transfers or burns tokens.
- Withdraw dividends with checks-effects-interactions ordering.

## Tech Stack

- Solidity `0.7.0`
- Hardhat
- Web3.js
- Chai
- Truffle-style Hardhat plugins

## Getting Started

```bash
npm install
npm run compile
npm test
```

Required Node version:

```text
Node.js >= 20
```

## Project Structure

```text
.
|-- contracts/
|   |-- Token.sol
|   |-- IERC20.sol
|   |-- IMintableToken.sol
|   |-- IDividends.sol
|   `-- SafeMath.sol
|-- scripts/
|-- test/
|   `-- token.test.js
|-- hardhat.config.cjs
|-- package.json
`-- README.md
```

## Documentation

- `docs/overview.md` - project context and scope
- `docs/architecture.md` - contract architecture and transaction flows
- `docs/product.md` - requirements and user journeys
- `docs/decisions.md` - technical decisions and tradeoffs
- `docs/operations.md` - local runbook and maintenance notes
- `SECURITY.md` - security notes

## Known Limitations

- Dividend assignment loops over current holders and can become expensive as the holder set grows.
- The token is a prototype and does not use a battle-tested ERC20 implementation.
- The contract is not audited.
- The dividend model uses integer division, so residual wei can remain undistributed.

## License

The package metadata lists MIT, but no standalone license file is currently included.
