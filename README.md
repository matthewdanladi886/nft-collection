NFT-Collection Smart Contract

A Clarity smart contract for creating, managing, and transferring **Non-Fungible Tokens (NFTs)** on the **Stacks blockchain**.  
This contract enables developers, creators, and communities to mint unique digital assets, such as artworks, collectibles, or identity tokens, in a transparent and decentralized way.

---

Features

- **Mint Unique NFTs:** Create tokens with unique identifiers and associated metadata URIs.  
- **Ownership Management:** Track and transfer ownership of each NFT securely.  
- **Metadata Storage:** Each NFT contains a URI reference for external metadata (e.g., images, descriptions).  
- **Supply Control:** View total supply and prevent duplicate minting.  
- **Read-Only Functions:** Retrieve NFT details such as owner and metadata without modifying state.  

---

Contract Overview

| Function | Type | Description |
|-----------|------|-------------|
| `mint` | Public | Allows a user (creator) to mint a new NFT with metadata URI. |
| `transfer` | Public | Transfers ownership of a specific NFT between users. |
| `get-owner` | Read-only | Returns the current owner of a given token ID. |
| `get-token-uri` | Read-only | Returns the metadata URI of a token. |
| `get-total-supply` | Read-only | Returns the total number of minted NFTs. |

---

Deployment

1. Install [Clarinet](https://github.com/hirosystems/clarinet) to test and deploy the contract.
2. Clone this repository:
   ```bash
   git clone https://github.com/your-username/nft-collection.git
   cd nft-collection
