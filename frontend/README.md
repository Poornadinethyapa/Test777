# Predict and Win Frontend

Next.js frontend for the Predict and Win prediction market platform.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create `.env.local` file:
```env
NEXT_PUBLIC_MARKET_FACTORY_ADDRESS=0x...
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_project_id
NEXT_PUBLIC_ETH_USD_PRICE_FEED=0x694AA1769357215DE4FAC081bf1f309aDC325306
```

3. Run development server:
```bash
npm run dev
```

## Project Structure

- `app/` - Next.js app router pages
- `components/` - React components
- `lib/` - Utilities and configurations
- `public/` - Static assets

## Technologies

- Next.js 14
- TypeScript
- Tailwind CSS
- Wagmi & RainbowKit
- Viem

