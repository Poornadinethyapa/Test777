# Predict and Win Smart Contracts

Solidity smart contracts for the prediction market platform, built with Foundry.

## Setup

1. Install Foundry:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

2. Install dependencies:
```bash
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install smartcontractkit/chainlink --no-commit
```

## Testing

Run tests:
```bash
forge test
```

Run tests with verbose output:
```bash
forge test -vvv
```

## Building

Build contracts:
```bash
forge build
```

## Deployment

Deploy to Sepolia:
```bash
forge script script/Deploy.s.sol:DeployScript --rpc-url sepolia --broadcast --verify
```

## Contracts

### MarketFactory
Factory contract for creating new prediction markets.

### Market
Core prediction market contract that handles:
- Making predictions
- Resolving markets based on Chainlink price feeds
- Withdrawing winnings

## Security

- All contracts are tested with comprehensive Foundry tests
- Always audit contracts before deploying to mainnet
- Use testnets for development

