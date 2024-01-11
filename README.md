# Pokemon-Trading-Card-Game

## Disclaimer
This Pokemon Trading Card Game (TCG) simulation code is not created or endorsed by the official Pokemon company. It is a personal project developed solely for educational purposes and to gain insights into Solidity programming for GameFi projects.

## Purpose
The project was created as a reference and exercise to explore the implementation of blockchain technology, specifically Solidity smart contracts, in the context of a popular card game. It serves as a learning resource for developers interested in understanding how to code for GameFi projects.

## Legal Notice
This is a reference code created for learning purposes only. All references to Pokemon, including character names, imagery, and the Pokemon Trading Card Game, are the intellectual property of Nintendo, Game Freak, and The Pokemon Company. This project is not intended for commercial use, and its use is at the user's own risk.

# Pokemon Trading Card Game On-Chain

This repository contains Solidity smart contracts for creating and managing Pokemon Trading Card Game (TCG) non-fungible tokens (NFTs) on the Ethereum blockchain.

## Contracts

### `pokemon.sol`

- Implements ERC1155 standard for creating and managing Pokemon NFTs.
- Three types of cards are supported: Pokemon cards, Energy cards, and Trainer cards.
- Owners can add new Pokemon, Energy, and Trainer cards with specific attributes.
- The contract emits events when new NFTs are created.
- Provides functions to fetch all Pokemon, Energy, and Trainer NFTs.

### `marketPlace.sol`

- Implements a marketplace for buying and selling Pokemon NFTs.
- Connects to the `pokemon.sol` contract to perform transfers.
- Users can buy Pokemon cards at a specified price.
- Users can sell their Pokemon cards at a specified price.
- Includes logic for handling payments and transfers.

### `Playground.sol`

- Implements the actual game logic and rules for the Pokemon TCG.
- Allows players to enter the game, set up their active Pokemon and bench, and start the game.
- Handles player turns, attacks, and determines the winner based on the game rules.

## Usage

1. Deploy the `pokemon.sol` contract on the Ethereum blockchain.
2. Deploy the `marketPlace.sol` contract, providing the address of the deployed `pokemon.sol` contract.
3. Interact with the contracts to add new Pokemon, Energy, and Trainer cards.
4. Use the marketplace to buy and sell Pokemon cards with Ethereum.

**Note**: Make sure to test the contracts on a testnet before deploying them on the mainnet. Ensure that you have the required dependencies installed and configured.

**Scenario File: `scenario.json`**
- Checkout the `scenario.json` file to see entire test cases and step-by-step instructions on how to run the code in Remix IDE.

**Limitations of this Smart Contract:**
1. Still in MVP Stage: The smart contract is in the Minimum Viable Product (MVP) stage for the Pokemon Trading Card Game, and there is room for more realistic features for Pokemon cards, energy cards, and trainer cards.

2. Limited Card Selection: Currently, only a subset of Pokemon cards is implemented, and there are no trainer cards. Additional cards from the Pokemon game can be added to enhance the variety.

3. Two-Player Limitation: The current implementation allows only two players to add cards at the same time. Enhancements can be made to support simultaneous play for more players.

4. Manual Prize Card Minting: When a winner is decided, the minting and transfer of the prize card NFT are currently manual. Automation can be added to handle this process automatically.

5. Security Disclaimer: There may be potential loopholes or security issues in the current implementation. This smart contract is not recommended for production use.

6. Rule Alignment: Some rules may not align correctly with the original gameplay of the Pokemon Trading Card Game.

7. Not Officially Endorsed: This project is entirely designed by [iamparth.eth](https://twitter.com/iamparth_eth) and not by the Pokemon Company. It is for learning purposes, and a direct comparison with the actual gameplay is not warranted.

**NFT Gameplay Example:**
Step 1: Enter the Game
Players use the `enterIntoGame` function to join the Pokemon TCG and receive their NFT Pokemon cards. They select their initial set of NFT Pokemon cards to form their deck.

Step 2: Set Up Active Pokemon and Bench
Players use the `addActivePokemon` function to choose their active NFT Pokemon. They use the `addPokemonInBench` function to add additional NFT Pokemon to their bench.

Step 3: Start the Game
The manager calls the `startGame` function to begin the Pokemon TCG. Players take turns playing NFT cards, attacking opponents, and strategizing to win.

Step 4: Gameplay Loop
Players use the `attack` function to launch attacks using NFT energy cards. The game continues until a player's active NFT Pokemon faints, or victory conditions are met.

Step 5: Determine the Winner
The smart contract determines the winner based on the game rules. The winner is declared, and the game concludes.



## How to Contribute

This project is open-source, and we encourage contributions from the community to enhance and improve the Pokemon Trading Card Game On-Chain. If you find any issues, have suggestions for improvements, or want to add new features, follow the steps below:

1. **Issue Reporting**: If you encounter any bugs or have ideas for enhancements, please [open an issue](https://github.com/parth5805/Pokemon-Trading-Card-Game/issues/new) on GitHub. Provide a clear and detailed description, including steps to reproduce the issue.

2. **Feature Requests**: If you have ideas for new features or improvements, you can [open an issue](https://github.com/parth5805/Pokemon-Trading-Card-Game/issues/new) to discuss the proposal. We appreciate your input and will consider it for future updates.

3. **Pull Requests**: If you want to contribute directly, feel free to [submit a pull request](https://github.com/parth5805/Pokemon-Trading-Card-Game/pulls) with your changes. Ensure that your code follows best practices and includes appropriate test cases. We'll review your contribution and merge it if it aligns with the project goals.

## License

This project is licensed under the [MIT License](link_to_license). By contributing to this open-source project, you agree to the terms and conditions outlined in the license.

Thank you for your interest and contributions to the Pokemon Trading Card Game On-Chain!

