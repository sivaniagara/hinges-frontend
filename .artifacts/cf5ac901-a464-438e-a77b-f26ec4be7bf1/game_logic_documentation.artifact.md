# Cricket Auction Game Logic Documentation

This document provides a detailed overview of the game logic and data structures implemented in the frontend of the Cricket Auction application. This information is intended to guide the development of bot players and backend services.

## 1. Game Overview
The application is a real-time multiplayer cricket auction game where users compete to build the best squad within a budget. The game flows through various match and break statuses, with player auctions being the core mechanic.

---

## 2. Core Data Entities

### 2.1 GameDataEntity (Global State)
Represents the overall state of a match.
- **matchId**: Unique identifier for the current match.
- **matchStatus**: Current lifecycle stage of the match (see Section 3).
- **breakStatus**: Current break or transition state (see Section 4).
- **round**: Current round of the auction.
- **currentAuctionPlayerIndex**: Index of the player currently up for auction in the `auctionPlayersStatusList`.
- **highestBid**: The current highest bid amount for the active player.
- **highestBidUserId**: ID of the user who currently holds the highest bid.
- **auctionExpiresAt**: Timestamp (server time) when the current player auction ends.
- **breakExpiresAt**: Timestamp (server time) when the current break ends.
- **serverTime**: Current time according to the server, used for calculating remaining durations.
- **usersStatusList**: List of all users in the match and their current status (budget, team, etc.).
- **auctionPlayersStatusList**: List of all players available for auction in the current category/match.

### 2.2 AuctionPlayerStatusEntity (Auctionable Player)
Represents a cricket player that can be bought.
- **playerId**: Unique identifier.
- **playerName**: Name of the player.
- **playerRole**: ID representing the role (Batsman, Bowler, etc.).
- **playerAuctionStatus**: Current status: `available`, `sold`, `unSold`, `buy` (bought by current user), `notShown`.
- **basePrice**: Starting price for the auction.
- **currentPrice**: The price at which the player was sold or is currently being bid on.
- **priceIncrement**: The amount by which each bid increases the price.
- **baseRating**: Performance rating used for squad evaluation.
- **teamId**: The ID of the team that purchased the player (if sold).

### 2.3 UserStatusEntity (Player/Participant)
Represents a user participating in the auction.
- **userId**: Unique identifier.
- **teamId**: The franchise/team the user is representing (e.g., CSK, MI).
- **balanceAmount**: Remaining budget for the user.
- **activeStatus**: Connection status: `joinMatch`, `exitMatch`, `connectionLoss`.
- **totalRatings**: Combined rating of all players purchased by the user.

---

## 3. Match Status Lifecycle (`MatchStatusEnum`)
1. **notStarted**: Match is created, waiting for participants. A countdown (usually 120s) is active.
2. **initialMatch**: Preparatory phase just before the auction starts.
3. **started**: Auction is live. Players are being presented sequentially.
4. **stopped**: Match has been manually or automatically stopped.
5. **finished**: All players have been auctioned or the match has reached its end condition.
6. **paused**: Match is temporarily suspended.

---

## 4. Break Statuses (`BreakStatusEnum`)
Transitions between auction events are managed via these statuses:
- **auctionPlayerBreak**: A short interval between individual player auctions.
- **playerSetBreak**: A break after a specific set of players (e.g., "Marquee Players") has been auctioned.
- **strategicBreak**: A longer break for teams to reassess their strategies.
- **acceleratedBreak**: Transition to a faster-paced auction phase.
- **triggerNextPlayer**: Internal state to move the `currentAuctionPlayerIndex` forward.

---

## 5. Auction Mechanics

### 5.1 Bidding Process
- When a player is "available" and the match is "started":
    - The server broadcasts `auctionExpiresAt`.
    - Clients display the current `highestBid`.
    - Users send a **Payload Code 200** to place a bid.
    - Each bid increases the `currentPrice` by the `priceIncrement`.
    - The `highestBidUserId` is updated to the last bidder.
- If the `auctionExpiresAt` is reached without a bid:
    - If `highestBid > 0`, the player is marked as **sold**.
    - If `highestBid == 0`, the player is marked as **unSold**.

### 5.2 Communication (WebSockets)
The frontend communicates with the backend via WebSockets using specific payload codes:
- **100**: Refresh/Sync request (sent by client to get the latest full state).
- **200**: Place Bid (sent by client). Requires `team_id` and `payload_code`.
- **300**: Send Reaction/Message (sent by client).

---

## 6. Squad Composition Rules
The frontend organizes purchased players into a squad based on their roles. A standard squad follows these positional slots:
- **Slots 1 - 3**: Batsman (BAT)
- **Slots 4 - 5**: Wicket-keepers (WK)
- **Slots 6 - 9**: All-rounders (AL)
- **Slots 10 - 12**: Bowlers (BWL)

**Role IDs (Reference):**
- Batsman: `6881ba0f36213beb0017be9c`
- Wicket-keeper: `6881ba3936213beb0017be9d`
- All-rounder: `6881bba636213beb0017be9e`
- Bowler: `6881e28cc8d219cd96a5c4b2`

---

## 7. API & Connection Details
- **Base WebSocket URL**: `ws/:matchId`
- **Room Management**:
    - `match/roomCode`: Generates a code for private rooms.
    - `match/matchJoining`: REST endpoint to initiate the join process.
    - `match/exit`: REST endpoint to leave a match.

---

## 8. Logic for Bot Implementation (Recommendations)
To develop effective bots, the backend should simulate the following frontend behaviors:
1. **Budget Management**: Monitor `balanceAmount` and avoid bidding beyond remaining funds + minimum required for other slots.
2. **Squad Requirements**: Prioritize bidding on roles where slots (as defined in Section 6) are still empty.
3. **Rating Optimization**: Target players with high `baseRating` relative to their `currentPrice`.
4. **Bid Timing**: Bots should respond to state changes within the `auctionExpiresAt` window, typically with a slight random delay to simulate human behavior.
5. **Payload Handling**: Listen for the same WebSocket updates as the frontend to stay synchronized with the `highestBid` and `serverTime`.
