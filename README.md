
# InquireA - Smart Contracts
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Build Status](https://img.shields.io/badge/Build-Passing-brightgreen.svg)](https://github.com/WeTranscend-labs/FE-Realm-of-Cards/actions) [![Version](https://img.shields.io/badge/Version-1.0.0-orange.svg)](https://github.com/WeTranscend-labs/FE-Realm-of-Cards/releases) ![Ancient8](https://img.shields.io/badge/Blockchain-Ancient8-green.svg)

  

Welcome to the core of **InquireA**! This repository contains the smart contracts that power the platform’s blockchain integration, ensuring secure reward distribution, tamper-proof reputation tracking, and efficient dispute resolution on the **Ancient8 Chain**. Whether you're asking questions or earning rewards for answers, these contracts are the magical glue holding this decentralized Q&A ecosystem together. Let’s dive into the blockchain brilliance within! 🧠💰

----------

## Table of Contents

-   [What is InquireA - Smart Contracts?](#what-is-inquirea---smart-contracts)
-   [How to Get Started](#how-to-get-started)
    -   [Installation](#installation)
-   [Technologies Powering the Contracts](#technologies-powering-the-contracts)
-   [Project Structure](#project-structure)
-   [How to Contribute](#how-to-contribute)
-   [License](#license)

  

----------


## What is InquireA - Smart Contracts?

**InquireA - Smart Contracts** forms the blockchain foundation of this decentralized Q&A platform. These contracts:

-   Manage **question posting** with minimum fees to deter spam and ensure quality.
-   Handle **proportional reward distribution** based on upvotes for answers.
-   Track **user reputation** on-chain, unlocking benefits like reduced fees.
-   Enable a **DAO-based arbitration system** for fair dispute resolution.

Built for seamless integration with the backend and frontend, these contracts bring InquireA to life with decentralized transparency. Ready to explore the code that powers this knowledge revolution? 🧙‍♂️

----------


## How to Get Started

Ready to deploy these contracts and unleash the blockchain magic? Follow these steps to set up and interact with the smart contracts locally or on the **Ancient8 Chain**!

### Installation

To get started with **InquireA - Smart Contracts**, follow these steps to clone the repository and deploy using **Remix IDE**. This guide assumes you are working with the InquireA repository on GitHub and deploying to the **Ancient8 Chain**.

#### 1. **Prepare Your Environment**

-   **Access Remix IDE**: Open your browser and navigate to [Remix IDE](https://remix.ethereum.org/).
-   **Set Up MetaMask**:
    -   Install the MetaMask extension if you don’t already have it.
    -   Add the **Ancient8 Testnet Chain** network to MetaMask via [Overview of Ancient8 Chain | Ancient8 Documentation](https://docs.ancient8.gg/).
    -   Get testnet tokens from the Ancient8 faucet (check [Faucet | Ancient8 Documentation](https://docs.ancient8.gg/using-ancient8-chain/faucet) for faucet details) to cover gas fees.

#### 2. **Clone the Repository into Remix IDE**

Remix IDE supports cloning GitHub repositories directly into its workspace. Here’s how:

-   **Open File Explorer**:
    -   On the left sidebar, click the **File Explorer** icon (looks like a folder).
    -   If it’s not visible, activate it via **Plugin Manager** (plug icon) > Search for "File Explorer" > Activate.
-   **Clone the Repository**:
    -   In **File Explorer**, click the **Clone Git Repository** icon (a down arrow or Git symbol).
    -   Paste the following URL:
	     ```
	    https://github.com/WeTranscend-labs/SC-InquireAv2.git
	    ```
    -   Click **OK** to import the repository into your workspace.

-   **Verify the Files**:  
    -   Ensure key folders like contracts/, scripts/, and test/ are loaded.
      
    -   Open the main contract file contracts/InquireA.sol, to inspect the code.
      


#### 3. **Compile the Smart Contract**

Before deployment, compile the contract to check for errors.

-   **Select the Contract**:
    -   Double-click a contract file (InquireA.sol) in **File Explorer**.
-   **Open the Compiler**:
    -   Click the **Solidity Compiler** icon (an "S") on the left sidebar.
-   **Configure and Compile**:
    -   Set the Solidity version to match the pragma solidity line in your contract (e.g., 0.8.0).
    -   Click **Compile InquireA.sol** or enable **Auto compile**.
-   **Check the Output**:
    -   A green checkmark means it compiled successfully.

#### 4. **Deploy the Smart Contract on Ancient8 Testnet Chain**

Now, deploy your contract using Remix and MetaMask.

-   **Open the Deploy Tab**:
    -   Click the **Deploy & Run Transactions** icon (down arrow) on the left sidebar.
-   **Connect MetaMask**:
    -   In the **Environment** dropdown, select **Injected Provider - MetaMask**.
    -   Approve the connection in MetaMask and ensure you’re on **Ancient8 Testnet Chain**.
-   **Deploy the Contract**:
    -   From the **Contract** dropdown, select the main contract (InquireA.sol).
    -   Click **Deploy** and confirm the transaction in MetaMask.
-   **Get the Contract Address**:
    -   Once deployed, the contract address will appear under **Deployed Contracts**.

#### 5. **Interact with the Deployed Contract**

Test and interact with your contract directly in Remix.

-   **Access Functions**:
    -   Expand the contract under **Deployed Contracts** to see its functions.
-   **Call Functions**:
    -   For **view** functions (e.g., getQuestions), input parameters and click to see the output.
    -   For **write** functions (e.g., askQuestion), input parameters, click, and confirm the transaction in MetaMask.
-   **Example**:
    -   To post a question, call askQuestion with a fee and confirm the transaction.

#### 6. **Important Notes**:

-   **Gas Fees**: Ensure you have enough testnet tokens in your MetaMask wallet.
-   **Network Check**: Verify Remix and MetaMask are both on **Ancient8 testnet Chain**.
-   **Troubleshooting**:
    -   _“Nonce too high”_: Reset your MetaMask account (Settings > Advanced > Reset Account).
    -   _“Compilation failed”_: Check the Solidity version or fix syntax errors in the code.

----------


## Technologies Powering the Contracts

These smart contracts are built with a robust stack of tools to ensure security, efficiency, and scalability:

-   **Solidity**: The language powering the contracts, used to define Q&A logic (v0.8.x).

-   **Ancient8 Chain**: The blockchain network enabling fast, low-cost transactions.

Together, these tools anchor InquireA’s decentralized features, from reward distribution to reputation tracking, all while optimizing gas efficiency!

----------

## Project Structure

```
.
├── InquireA.sol          # Core contract managing the main Q&A logic, rewards, and interactions
├── InquireConstants.sol  # Defines constant values like minimum fees, reward ratios, or time limits
├── InquireEvent.sol      # Handles events such as question posting, answer selection, or reward distribution
├── InquireModifier.sol   # Contains modifiers for access control, validation, or state checks
├── InquireState.sol      # Manages the state variables for questions, answers, and user data
└── InquireType.sol       # Defines custom types or structs for questions, answers, and reputation
```
----------


## How to Contribute

Ready to enhance this Q&A blockchain magic? We welcome contributions! Fork the repository, improve the contracts, and submit a pull request. Whether it’s adding new features (e.g., advanced reward tiers), optimizing gas usage, or fixing bugs, your efforts will make **InquireA** even more extraordinary! 🧠⚡

----------

## License

**InquireA - Smart Contracts** is released under the **MIT License**. Feel free to explore, modify, and share—just check the [LICENSE](./LICENSE) file for details.
