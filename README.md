# InquireA

## Table of Contents
- [Project Overview](#project-overview)
- [Features](#features)
- [Deployment](#deployment)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Technologies Used](#technologies-used)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Project Overview
InquireA is a decentralized Q&A platform built on blockchain technology to enhance transparency, encourage user participation, and incentivize high-quality content. By integrating smart contracts and a reputation system, InquireA aims to solve common issues in traditional Q&A platforms, such as lack of motivation, spam, and low-quality answers.

## Features
- **Auto Select Answer**: Automatically selects the highest-upvoted answer after a set time limit.
- **Reward for Choosing**: Rewards users for selecting the best answer within the given timeframe.
- **Proportional Reward**: Distributes rewards based on the number of upvotes each answer receives.
- **Arbitration System (DAO)**: Resolves disputes through a decentralized arbitration system.
- **Minimum Question Fee**: Implements a minimum posting fee to reduce spam and encourage quality.
- **Reputation System**: Tracks user reputation on the blockchain, offering reduced fees and increased trust.
- **Smart Contract Rewarding**: Ensures transparent and automatic reward distribution.
- **Decentralized Content Storage**: Secures content on the blockchain to prevent unauthorized changes.

## Deployment

The InquireA platform is live and can be accessed at:

**Deployment Link**: [https://inquire-a.vercel.app](https://inquire-a.vercel.app)

You can explore the platform, post questions, answer queries, and interact with other users in a decentralized environment, all powered by blockchain technology.

## Getting Started
Follow the steps below to set up the project locally.

### Prerequisites
- Node.js (v16 or later)
- npm or yarn
- Blockchain wallet (e.g., MetaMask)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Quantaphocpython/_InquireA.git
   cd _InquireA
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Configure environment variables:
   - Create a `.env` file in the root directory.
   - Add the following variables:
     ```env
     NEXT_PUBLIC_APP_NAME=YourAppName
	 NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=your-wallet-connect-project-id
	 NEXT_PUBLIC_NETWORK_URL=https://your-network-url
	 NEXT_PUBLIC_NETWORK_RPC_INFURA_KEY=your-infura-rpc-key
	 NEXT_PUBLIC_CONTRACT_ADDRESS=your-contract-address
	 NEXT_PUBLIC_TINYMCE_API_KEY=your-tinymce-api-key
     ```
4. Start the development server:
   ```bash
   npm run dev
   ```

## Technologies Used
- **Frontend**: Next.js, TypeScript, Tailwind CSS
- **Smart Contracts Language**: Solidity
- **Blockchain Interaction**: Ethers.js, Wagmi, Viem
- **Text Editor**: TinyMCE React
- **Others**: React Hook Form, React Query, Zod

## Project Structure
```
.
├── app/                  # Folder for Next.js app-specific routing and page components
├── components/           # Contains reusable UI components like buttons, forms, modals, etc.
├── configs/              # Contains configuration files for system settings or environment configurations
├── constants/            # Contains constants used throughout the application
├── contexts/             # Contains React contexts for managing global state across the app
├── lib/                  # Contains reusable libraries or helper functions
└── .env                  # Environment file 
```

## Contributing

Contributions are welcome! If you'd like to contribute to InquireA, please fork the repository, make your changes, and submit a pull request. We appreciate your help!

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
