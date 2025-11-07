# Predict and Win

A decentralized prediction market platform built on Ethereum where users can make predictions on cryptocurrency prices and win rewards based on their accuracy.

## Features

- 🎯 **Prediction Markets**: Create and participate in prediction markets for ETH/USD prices
- 💰 **Smart Contracts**: Secure, auditable smart contracts built with Solidity
- 🎨 **Modern UI**: Beautiful Next.js frontend with Tailwind CSS
- 🔗 **Wallet Integration**: Seamless wallet connectivity with RainbowKit
- 📊 **Real-time Data**: Chainlink oracle integration for accurate price feeds
- 🐳 **Docker Support**: Easy deployment with Docker and Docker Compose

## Project Structure

```
predict-and-win/
├── contracts/          # Smart contracts (Foundry)
│   ├── src/
│   ├── test/
│   └── script/
├── frontend/           # Next.js frontend
│   ├── app/
│   ├── components/
│   └── lib/
├── .github/            # CI/CD workflows
└── docker-compose.yml  # Docker configuration
```

## Prerequisites

- Node.js 18+ and npm
- Foundry (for smart contracts)
- Docker and Docker Compose (optional)
- MetaMask or compatible Web3 wallet

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd predict-and-win
```

### 2. Set Up Smart Contracts

```bash
cd contracts

# Install Foundry (if not already installed)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install foundry-rs/forge-std --no-commit
forge install OpenZeppelin/openzeppelin-contracts --no-commit
forge install smartcontractkit/chainlink --no-commit

# Run tests
forge test

# Build contracts
forge build
```

### 3. Deploy Contracts

```bash
# Create .env file in the root directory
# Add the following variables:
# PRIVATE_KEY=your_private_key_here
# INFURA_API_KEY=your_infura_api_key
# ETHERSCAN_API_KEY=your_etherscan_api_key

# Deploy to Sepolia testnet
forge script script/Deploy.s.sol:DeployScript --rpc-url sepolia --broadcast --verify
```

### 4. Set Up Frontend

```bash
cd frontend

# Install dependencies
npm install

# Create .env.local file with the following variables:
# NEXT_PUBLIC_MARKET_FACTORY_ADDRESS=0x... (your deployed factory address)
# NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
# NEXT_PUBLIC_ETH_USD_PRICE_FEED=0x694AA1769357215DE4FAC081bf1f309aDC325306

# Run development server
npm run dev
```

Visit `http://localhost:3000` to see the application.

### 5. Docker Deployment (Optional)

```bash
# Build and run with Docker Compose
docker-compose up -d

# View logs
docker-compose logs -f
```

## Smart Contracts

### MarketFactory

Factory contract for creating new prediction markets.

**Functions:**
- `createMarket(address priceFeed, uint256 targetPrice, uint256 duration)`: Create a new market

### Market

Core prediction market contract.

**Functions:**
- `predict(bool isAbove)`: Make a prediction (payable)
- `resolve()`: Resolve the market based on Chainlink price feed
- `withdraw()`: Withdraw winnings after market resolution
- `getMarketDetails()`: Get market information
- `getUserPredictions(address user)`: Get user's predictions

## Frontend

The frontend is built with:
- **Next.js 14**: React framework with App Router
- **TypeScript**: Type-safe development
- **Tailwind CSS**: Utility-first CSS framework
- **Wagmi & RainbowKit**: Ethereum wallet integration
- **Viem**: Ethereum library

### Key Components

- `MarketCard`: Displays market information
- `PredictionModal`: Modal for making predictions
- `WalletConnect`: Wallet connection component

## Testing

### Smart Contracts

```bash
cd contracts
forge test
```

### Frontend

```bash
cd frontend
npm run lint
npm run build
```

## CI/CD

GitHub Actions workflows are configured to:
- Test smart contracts on every push
- Lint and build the frontend
- Run TypeScript type checking

## Environment Variables

See `.env.example` for required environment variables:

- `PRIVATE_KEY`: Deployer private key
- `INFURA_API_KEY`: Infura API key for RPC
- `ETHERSCAN_API_KEY`: Etherscan API key for verification
- `NEXT_PUBLIC_MARKET_FACTORY_ADDRESS`: Deployed factory address
- `NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID`: WalletConnect project ID

## Security

- Smart contracts are tested with comprehensive Foundry tests
- Always audit contracts before deploying to mainnet
- Use testnets for development and testing
- Never commit private keys or sensitive information

## License

MIT License - see LICENSE file for details

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Support

For issues and questions, please open an issue on GitHub.

## Roadmap

- [ ] Support for multiple price feeds
- [ ] Market creation UI
- [ ] Leaderboard system
- [ ] Mobile app
- [ ] Governance token
- [ ] Staking mechanism

