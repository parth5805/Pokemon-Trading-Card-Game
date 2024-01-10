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

## Usage

1. Deploy the `pokemon.sol` contract on the Ethereum blockchain.
2. Deploy the `marketPlace.sol` contract, providing the address of the deployed `pokemon.sol` contract.
3. Interact with the contracts to add new Pokemon, Energy, and Trainer cards.
4. Use the marketplace to buy and sell Pokemon cards with Ethereum.

**Note**: Make sure to test the contracts on a testnet before deploying them on the mainnet. Ensure that you have the required dependencies installed and configured.

Happy Pokemon Trading Card Game On-Chain!

Certainly! Let's break down the major functionalities of the provided Solidity code for the Pokemon Trading Card Game (TCG) and discuss how they can be utilized in a game. I'll provide explanations for key functions and discuss how they align with gameplay.

pokemon.sol
addPokemonCard
This function allows the contract owner to add a new Pokemon card to the game. It mints a new NFT representing the Pokemon card and adds its details to the Pokemon_card_details mapping.

Example
// Assuming the contract owner calls this function
addPokemonCard(0xMarketplaceAddress, 100, "Pikachu", "Electric", "Basic", "Thunder Shock", 2, 30, "Ground", 1, "0x", 1);

This example adds a Pikachu card with specific attributes to the game. The card is minted, and its details are stored in the contract.

addEnergyCard
Similar to addPokemonCard, this function adds a new Energy card to the game, minting an NFT and storing its details.

Example
// Assuming the contract owner calls this function
addEnergyCard(0xMarketplaceAddress, "Lightning Energy", "Electric", "0x", 1);

This example adds a Lightning Energy card with specific attributes to the game.

addTrainerCard
Adds a new Trainer card to the game.

Example:

// Assuming the contract owner calls this function
addTrainerCard(0xMarketplaceAddress, "Ash", "Start the game with an extra card draw.", "0x", 1);

This example adds an Ash Trainer card with specific attributes to the game.

fetchPokemonNfts, fetchEnergyNfts, fetchTrainerNfts
These functions return arrays containing details of all Pokemon, Energy, and Trainer NFTs, respectively.

Example:

// Assuming a player calls this function to see their Pokemon cards
pokemonNfts = fetchPokemonNfts();
// Now 'pokemonNfts' contains an array with details of all Pokemon cards owned by the player.


marketPlace.sol
buy
Allows a player to buy a Pokemon card from the marketplace.

Example:

// Assuming a player calls this function to buy a Pokemon card with ID 101
buy(101, 1);
// The player sends the correct amount of Ether, and the Pokemon card is transferred to their ownership.

sell
Allows a player to sell their Pokemon card on the marketplace.

Example:
// Assuming a player calls this function to sell one unit of their Pokemon card with ID 102 at a price of 2 Ether
sell(102, 1, 2 ether);
// The player transfers the Pokemon card to the marketplace, and the card is available for other players to buy.

PlayGround.sol
This contract represents the game logic and player interactions.

enterIntoGame
A player enters the game by specifying their initial Pokemon cards.

Example:
// A player calls this function to enter the game with a team of Pokemon cards.
enterIntoGame([101, 102, 103, 104, 105, 106]);

startGame
The manager (possibly the game creator) starts the game, initiating the game state.

Example:
// The manager calls this function to start the game once all players have entered.
startGame();

flipacoin
The manager flips a coin to determine the starting player.

Example:

// The manager calls this function to randomly select the starting player.
flipacoin();

addActivePokemon, addPokemonInBench
Players set their active Pokemon and bench Pokemon.

Example:
// A player calls these functions to set their active Pokemon and bench Pokemon.
addActivePokemon(101);
addPokemonInBench([102, 103, 104, 105, 106]);

attack
A player attacks the opponent using energy cards.

Example:
// A player calls this function to attack the opponent with a specific energy card.
attack(201, 2);

Please note that these examples are simplified for illustration purposes, and you may need to adapt them based on the actual gameplay mechanics and rules you want to implement. The provided functions give you a starting point to build upon for a Pokemon Trading Card Game on the blockchain.

Contributing
If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request.

License
This project is licensed under the MIT License.
