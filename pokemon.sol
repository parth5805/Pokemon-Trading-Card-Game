// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title PokemonNFTs
 * @dev Implements creating NFTs for Pokemon cards and also creates getter functions for all NFTs
 * @author iamparth.eth
 */

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PokemonNFTs is ERC1155, Ownable {
    // This structure represents the Pokemon card features
    struct PokemonCard {
        uint id;
        string cardType;
        uint hp;  // number of Health Points (HP)
        string name; // name of Pokemon
        string pokemonType; // type of Pokemon card
        string stage;  // stage of Pokemon card
        string attack;  // number of attacks
        uint quantity; // number of attack cards required to attack
        uint damage; // amount of damage
        string weak;  // weak energy point
    }

    // This structure represents the Energy card features
    struct EnergyCard {
        uint id;
        string cardType;
        string name; // energy name
        string color; // name of color
    }

    // This structure represents the Trainer card feature
    struct TrainerCard {
        uint id;
        string cardType;
        string name; // name of Trainer
        string taskDetails; // information about the task
    }

    uint public nextId = 100; // counter starts from 100

    mapping(uint => PokemonCard) public Pokemon_card_details;
    mapping(uint => EnergyCard) public Energy_card_details;
    mapping(uint => TrainerCard) public Trainer_card_details;

    // Events for emitting NFT creation details
    event pokemonNFT(address indexed _to, uint amount, uint indexed _tokenId, string _cardType, uint _hp, string _name, string _pokemonType, string _stage, string _attack, uint _quantity, uint _damage, string _weak);
    event energyNFT(address indexed _to, uint amount, uint indexed _tokenId, string _cardType, string _name, string _color);
    event trainerNFT(address indexed _to, uint amount, uint indexed _tokenId, string _cardType, string _name, string _taskDetails);

    constructor() ERC1155("") Ownable(msg.sender) {}

    /**
     * @dev Function to add a new Pokemon card NFT.
     * @param _receiverAddress Address to receive the newly minted NFT.
     * @param _hp Number of Health Points (HP) of the Pokemon card.
     * @param _name Name of the Pokemon.
     * @param _pokemonType Type of the Pokemon card.
     * @param _stage Stage of the Pokemon card.
     * @param _attack Number of attacks the Pokemon can perform.
     * @param _quantity Number of attack cards required to attack.
     * @param _damage Amount of damage the Pokemon can deal.
     * @param _weak Weak energy point of the Pokemon.
     * @param _amount Amount of NFTs to mint.
     * @param _data Additional data to pass to the receiver on a safe transfer.
     * @return Boolean indicating whether the operation was successful.
     */
    function addPokemonCard(address _receiverAddress, uint _hp, string memory _name, string memory _pokemonType, string memory _stage, string memory _attack, uint _quantity, uint _damage, string memory _weak, uint _amount, bytes memory _data) public onlyOwner returns (bool) {
        _mint(_receiverAddress, nextId, _amount, _data);
        Pokemon_card_details[nextId] = PokemonCard(nextId, "pokemon", _hp, _name, _pokemonType, _stage, _attack, _quantity, _damage, _weak);
        emit pokemonNFT(msg.sender, _amount, nextId, "pokemon", _hp, _name, _pokemonType, _stage, _attack, _quantity, _damage, _weak);
        nextId++;
        return true;
    }

    /**
     * @dev Function to add a new Energy card NFT.
     * @param _receiverAddress Address to receive the newly minted NFT.
     * @param _name Name of the energy.
     * @param _color Color of the energy.
     * @param _amount Amount of NFTs to mint.
     * @param _data Additional data to pass to the receiver on a safe transfer.
     * @return Boolean indicating whether the operation was successful.
     */
    function addEnergyCard(address _receiverAddress, string memory _name, string memory _color, uint _amount, bytes memory _data) public onlyOwner returns (bool) {
        _mint(_receiverAddress, nextId, _amount, _data);
        Energy_card_details[nextId] = EnergyCard(nextId, "energy", _name, _color);
        emit energyNFT(msg.sender, _amount, nextId, "energy", _name, _color);
        nextId++;
        return true;
    }

    /**
     * @dev Function to add a new Trainer card NFT.
     * @param _receiverAddress Address to receive the newly minted NFT.
     * @param _name Name of the Trainer.
     * @param _taskDetails Information about the task the Trainer can perform.
     * @param _amount Amount of NFTs to mint.
     * @param _data Additional data to pass to the receiver on a safe transfer.
     * @return Boolean indicating whether the operation was successful.
     */
    function addTrainerCard(address _receiverAddress, string memory _name, string memory _taskDetails, uint _amount, bytes memory _data) public onlyOwner returns (bool) {
        _mint(_receiverAddress, nextId, _amount, _data);
        Trainer_card_details[nextId] = TrainerCard(nextId, "trainer", _name, _taskDetails);
        emit trainerNFT(msg.sender, _amount, nextId, "trainer", _name, _taskDetails);
        nextId++;
        return true;
    }

    /**
     * @dev Function to fetch all Pokemon card NFTs.
     * @return Array of PokemonCard structures representing the details of all Pokemon card NFTs.
     */
    function fetchPokemonNfts() public view returns (PokemonCard[] memory) {
        uint counter;
        uint index = 0;
        for (uint i = 100; i < nextId; i++) {
            if (keccak256(abi.encodePacked(Pokemon_card_details[i].cardType)) == keccak256(abi.encodePacked("pokemon"))) {
                counter++;
            }
        }

        PokemonCard[] memory pokemonArray = new PokemonCard[](counter);

        for (uint i = 100; i < nextId; i++) {
            if (keccak256(abi.encodePacked(Pokemon_card_details[i].cardType)) == keccak256(abi.encodePacked("pokemon"))) {
                pokemonArray[index] = Pokemon_card_details[i];
                index++;
            }
        }

        return pokemonArray;
    }

    /**
     * @dev Function to fetch all Energy card NFTs.
     * @return Array of EnergyCard structures representing the details of all Energy card NFTs.
     */
    function fetchEnergyNfts() public view returns (EnergyCard[] memory) {
        uint counter;
        uint index = 0;
        for (uint i = 100; i < nextId; i++) {
            if (keccak256(abi.encodePacked(Energy_card_details[i].cardType)) == keccak256(abi.encodePacked("energy"))) {
                counter++;
            }
        }

        EnergyCard[] memory energyArray = new EnergyCard[](counter);

        for (uint i = 100; i < nextId; i++) {
            if (keccak256(abi.encodePacked(Energy_card_details[i].cardType)) == keccak256(abi.encodePacked("energy"))) {
                energyArray[index] = Energy_card_details[i];
                index++;
            }
        }

        return energyArray;
    }

    /**
     * @dev Function to fetch all Trainer card NFTs.
     * @return Array of TrainerCard structures representing the details of all Trainer card NFTs.
     */
    function fetchTrainerNfts() public view returns (TrainerCard[] memory) {
        uint counter;
        uint index = 0;
        for (uint i = 100; i < nextId; i++) {
            if (keccak256(abi.encodePacked(Trainer_card_details[i].cardType)) == keccak256(abi.encodePacked("trainer"))) {
                counter++;
            }
        }

        TrainerCard[] memory trainerArray = new TrainerCard[](counter);

        for (uint i = 100; i < nextId; i++) {
            if (keccak256(abi.encodePacked(Trainer_card_details[i].cardType)) == keccak256(abi.encodePacked("trainer"))) {
                trainerArray[index] = Trainer_card_details[i];
                index++;
            }
        }

        return trainerArray;
    }
}
