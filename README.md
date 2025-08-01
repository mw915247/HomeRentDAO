# 🏡 HomeRentDAO

A blockchain-based platform for decentralized short-term rentals, guest reputation, and community-governed dispute resolution using NFTs.

---

## **Overview**

This system consists of eight main smart contracts, each handling a different part of the rental and reputation ecosystem:

1. **Property NFT Contract** – Represents rental listings and bookable dates as NFTs.
2. **Booking Manager Contract** – Handles bookings, availability, payments, and cancellations.
3. **Reputation NFT Contract** – Issues non-transferable reputation NFTs to guests and hosts.
4. **Deposit Escrow Contract** – Manages guest security deposits with automated release.
5. **Review Manager Contract** – Stores on-chain reviews after stays.
6. **Dispute DAO Contract** – Enables community-driven dispute resolution.
7. **Reward Distributor Contract** – Distributes token/NFT rewards to top-rated users.
8. **Governance Token Contract** – ERC-20 style token for voting and incentives.

---

## **Features**

- Decentralized rental marketplace
- Guest & host-owned reputation
- Fully on-chain bookings and deposits
- Transparent, immutable reviews
- Community dispute resolution
- NFT-based property listings
- Token incentives for quality and loyalty

---

## **Smart Contracts**

### **Property NFT Contract**
- Mint NFTs representing rental properties or bookable dates
- Store metadata (location, amenities, pricing)
- Transferable to allow secondary rentals

### **Booking Manager Contract**
- Handle booking requests and approvals
- Process payments securely on-chain
- Manage cancellations and refunds

### **Reputation NFT Contract**
- Mint non-transferable NFTs as proof of good conduct
- Build cross-platform guest/host reputation
- Prevent fake or duplicate reputations

### **Deposit Escrow Contract**
- Lock guest security deposits during the stay
- Automatically refund if no disputes are raised
- Enable partial refunds for partial damages

### **Review Manager Contract**
- Store verified reviews from both guests and hosts
- Enforce one review per stay
- Aggregate average ratings

### **Dispute DAO Contract**
- Let the community vote on reported issues
- Apply penalties to bad actors
- Release deposits or compensation based on outcome

### **Reward Distributor Contract**
- Issue NFT badges or token rewards to top-rated users
- Encourage consistent quality and trust

### **Governance Token Contract**
- Token for voting on platform upgrades and dispute resolution rules
- Enable staking for governance participation

---

## **Installation**

1. Install Clarinet CLI  
2. Clone this repository  
3. Run tests:  
   ```bash
   npm test
   ```
4. Deploy contracts:
    ```bash
    clarinet deploy
    ```

## **Usage**

- Each smart contract can be deployed independently and interacts with the others to form a full rental ecosystem.
- Detailed usage instructions and examples are available in each contract’s documentation.

## **Testing**

Tests are written using Vitest and can be run with:
```bash
npm test
```

## **License**

MIT License