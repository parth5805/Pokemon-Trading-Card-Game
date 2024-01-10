// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title MarketPlace
 * @dev Marketplace smart contract consists of logic for buying, selling, and trading of the NFTs.
 * @author iamparth.eth
 */

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./pokemon.sol";

contract marketplace is ERC1155Holder, ReentrancyGuard {
    
    // Address of the deployed PokemonNFTs contract
    address pokemonAddress = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    address private pokemonCardAddress = address(pokemonAddress);
    PokemonNFTs _pokemon = PokemonNFTs(pokemonCardAddress);

   

    uint256 buyId;
    uint256 sellId;
    uint256 tradeId;
    uint256 public counter;

    // Struct For Buy
    struct buyCard {
        uint256 buyId;
        uint256 cardId;
        uint256 amount;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalMintedCopies;
        uint256 timeStamp;
    }

    // Struct For Sell
    struct sellCard {
        uint256 sellId;
        uint256 cardId;
        uint256 amount;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalMintedCopies;
        uint256 timeStamp;
    }

    // Struct For Trade History
    struct tradeHistory {
        uint256 tradeId;
        uint256 cardId;
        uint256 buyId;
        uint256 sellId;
        uint256 amount;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalMintedCopies;
        uint256 timeStamp;
    }

    // Mapping for Buy
    mapping(uint256 => buyCard) public idToBuyCard;

    // Mapping for Sale
    mapping(uint256 => sellCard) public idToSellCard;

    // Mapping For Trade
    mapping(uint256 => tradeHistory) public idToTradeHistory;

    // Event For Buy
    event buyEmit(
        uint256 indexed buyId,
        uint256 indexed cardId,
        uint256 amount,
        address buyer,
        address seller,
        uint256 quantity,
        uint256 totalMintedCopies,
        uint256 indexed timeStamp
    );

    // Event For Sell
    event sellEmit(
        uint256 indexed sellId,
        uint256 indexed cardId,
        uint256 amount,
        address buyer,
        address seller,
        uint256 quantity,
        uint256 totalMintedCopies,
        uint256 indexed timeStamp
    );

    // Event For Trade
    event tradeEmit(
        uint256 indexed tradeId,
        uint256 indexed cardId,
        uint256 buyId,
        uint256 sellId,
        uint256 amount,
        address buyer,
        address seller,
        uint256 quantity,
        uint256 totalMintedCopies,
        uint256 indexed timeStamp
    );

    // Buy Function
    function buy(uint256 _sellId, uint256 _quantity)
        public
        payable
        nonReentrant
    {
        // Generate Unique Buy Id
        buyId++;

        // Generate Unique Trade Id
        tradeId++;

        uint256 _amount = idToSellCard[_sellId].amount;
        address _seller = idToSellCard[_sellId].seller;
        uint256 _cardId = idToSellCard[_sellId].cardId;
        uint256 _totalMintedCopies = idToSellCard[_sellId].totalMintedCopies;

        require(
            msg.value == _amount,
            "Please submit the asking price to complete the purchase"
        );

        // Transfer the amount to the seller
        payable(_seller).transfer(msg.value);

        // Transfer the NFT to the buyer
        IERC1155(pokemonAddress).safeTransferFrom(
            address(this),
            msg.sender,
            _cardId,
            _quantity,
            "transfer to buyer"
        );

        // Set Buy Struct
        idToBuyCard[buyId] = buyCard(
            buyId,
            _cardId,
            _amount,
            msg.sender,
            _seller,
            _quantity,
            _totalMintedCopies,
            block.timestamp
        );

        // Update Sell Struct
        idToSellCard[_sellId].quantity =
            idToSellCard[_sellId].quantity -
            _quantity;

        // Decrement Counter
        if (idToSellCard[_sellId].quantity == 0) {
            counter--;
        }

        // Emit the Buy Event
        emit buyEmit(
            buyId,
            _cardId,
            _amount,
            msg.sender,
            _seller,
            _quantity,
            _totalMintedCopies,
            block.timestamp
        );

        // Emit Trade Event
        emit tradeEmit(
            tradeId,
            _cardId,
            buyId,
            _sellId,
            _amount,
            msg.sender,
            _seller,
            _quantity,
            _totalMintedCopies,
            block.timestamp
        );
    }

    // Sell Function
    function sell(
        uint256 _cardId,
        uint256 _amount,
        uint256 _quantity
    ) public payable nonReentrant {
        require(_amount > 0, "Price is too low");

        // Set Approved True
        require(
            _pokemon.isApprovedForAll(msg.sender, address(this)),
            "Please approve yourself"
        );

        // Generate a new sell Id
        sellId++;

        // Generate Unique Trade Id
        tradeId++;

        // Increment Counter
        counter++;

        // Transfer NFT from owner wallet address to the marketPlace address
        IERC1155(pokemonAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _cardId,
            _quantity,
            "transfer to marketplace"
        );

        // Create Entry In Sell Struct
        idToSellCard[sellId] = sellCard(
            sellId,
            _cardId,
            _amount,
            address(0),
            msg.sender,
            _quantity,
            _quantity,
            block.timestamp
        );

        // Emit the Sell Event
        emit sellEmit(
            sellId,
            _cardId,
            _amount,
            address(0),
            msg.sender,
            _quantity,
            _quantity,
            block.timestamp
        );

        // Emit Trade Event
        emit tradeEmit(
            tradeId,
            _cardId,
            0,
            sellId,
            _amount,
            address(0),
            msg.sender,
            _quantity,
            _quantity,
            block.timestamp
        );
    }

    // Fetch Cards For Sale
    function fetchCardForSell() public view returns (sellCard[] memory) {
        uint256 _count = counter;
        uint256 _currentCardIndex = 0;
        sellCard[] memory cardsForSell = new sellCard[](counter);

        for (uint256 i = 0; i < _count; i++) {
            if (idToSellCard[i + 1].quantity > 0) {
                uint256 _currentCardId = i + 1;
                sellCard storage currentCard = idToSellCard[_currentCardId];
                cardsForSell[_currentCardIndex] = currentCard;
                _currentCardIndex += 1;
            }
        }
        return cardsForSell;
    }

    // Fetch All Pokemon Cards Function
    function fetchAllCards()
        public
        view
        returns (PokemonNFTs.PokemonCard[] memory)
    {
        return _pokemon.fetchPokemonNfts();
    }

    // Fetch All Energy Cards Function
    function fetchAllCards4()
        public
        view
        returns (PokemonNFTs.EnergyCard[] memory)
    {
        return _pokemon.fetchEnergyNfts();
    }

    // Fetch All Trainer Cards Function
    function fetchAllCards3()
        public
        view
        returns (PokemonNFTs.TrainerCard[] memory)
    {
        return _pokemon.fetchTrainerNfts();
    }

    // Struct to hold all card types for a specific ID
    struct fetchAllCard {
        PokemonNFTs.PokemonCard _pokemonCard;
        PokemonNFTs.EnergyCard _energyCard;
        PokemonNFTs.TrainerCard _trainerCard;
    }

    // Mapping to associate an ID with its corresponding fetchAllCard struct
    mapping(uint256 => fetchAllCard) public idToAllCard;

}
