# Operations

## Local Setup

```bash
npm install
```

## Compile

```bash
npm run compile
```

## Test

```bash
npm test
```

## Clean Build Artifacts

```bash
npm run clean
```

## Maintenance Notes

- Keep `artifacts/`, `cache/`, and build output out of source control.
- Re-run tests after changing contract accounting.
- Review gas impact before expanding holder-based logic.
- Do not deploy with real funds without an audit.

## Troubleshooting

- Node version issues: use Node.js 20 or newer.
- Hardhat compile errors: verify Solidity version `0.7.0`.
- Test failures in dividend cases: inspect holder list updates during mint, burn, transfer, and transferFrom.
