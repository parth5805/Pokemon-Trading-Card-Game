// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./pokemon.sol";

/**
 * @title PlayGround
 * @dev Smart contract for managing the Pokemon NFT Trading Card Game playground. Handles player registration, game setup, and turn-based gameplay logic.
 * @author iamparth.eth
 */

contract PlayGround {

    // Address of the PokemonNFTs contract
    address pokemonAddress = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    address private pokemonCardAddress = address(pokemonAddress);
    PokemonNFTs _pokemon = PokemonNFTs(pokemonCardAddress);

    // Struct to represent a player and their card list
    struct Player {
        address player_address;
        uint[6] card_list;
    }

    // Mapping to associate players with their Player struct
    mapping(address => Player) public players;
    // Array to store player addresses
    address[] public player_no;

    // Boolean flag indicating whether the game has started
    bool public isGameStart;

    // Address of the manager
    address manager;

    // Struct to represent game settings for each player
    struct PlayerGameSetting {
        address player_address;
        uint active_pokemon;
        uint[5] pokemon_bench;
        uint current_hp;
        mapping(uint => bool) is_knocked;
        address opponent;
    }

    // Mapping to associate players with their PlayerGameSetting struct
    mapping(address => PlayerGameSetting) public playerGameSettings;

    // Address of the player who has the current turn
    address public current_turn;
    // Address of the winner
    address public winner;

    // Constructor to set the manager address
    constructor() {
        manager = msg.sender;
    }

    // Modifier: Only allows the manager to execute the function
    modifier onlyManager {
        require(msg.sender == manager, "Only manager can call this function");
        _;
    }

    // Modifier: Only allows players to execute the function
    modifier onlyPlayer {
        require(msg.sender == players[msg.sender].player_address, "Only player can call this function");
        _;
    }

    // Function to check ownership of a set of Pokemon NFTs
    function checkOwnerShip(uint[6] memory _pokemonNftId, address _caller) private view returns (bool) {
        uint flag = 0;
        for (uint i = 0; i < 6; i++) {
            if (_pokemon.balanceOf(_caller, _pokemonNftId[i]) > 0) {
                flag++;
            } else {
                flag--;
            }
        }
        return flag == 6 ? true : false;
    }

    // Function to check if a set of NFTs are of type Pokemon
    function checkCardTypePokemon(uint[6] memory _pokemonNftId) private view returns (bool) {
        uint flag = 0;
        for (uint i = 0; i < 6; i++) {
            (uint _id, , , , , , , , , ) = _pokemon.Pokemon_card_details(_pokemonNftId[i]);
            if (_id > 0) {
                flag++;
            } else {
                revert("Your NFTs is not a pokemon type");
            }
        }
        return flag == 6 ? true : false;
    }

    // Function for players to enter into the game
    function enterIntoGame(uint[6] memory _pokemonNftId) public {
        require(checkOwnerShip(_pokemonNftId, msg.sender), "You are not the owner of all NFTs");
        require(msg.sender != players[msg.sender].player_address, "You already joined the game");
        require(player_no.length < 2, "Only two players are allowed");
        require(checkCardTypePokemon(_pokemonNftId), "Your NFTs is not the Pokemon type");

        players[msg.sender] = Player(msg.sender, _pokemonNftId);
        player_no.push(msg.sender);
    }

    // Function for the manager to start the game
    function startGame() public onlyManager returns (bool) {
        require(player_no.length == 2, "At least two players are required to start the game");
        require(
            playerGameSettings[player_no[0]].active_pokemon > 0 &&
            playerGameSettings[player_no[1]].active_pokemon > 0,
            "Each player must set their active pokemon"
        );
        require(
            playerGameSettings[player_no[0]].pokemon_bench[0] > 0 &&
            playerGameSettings[player_no[1]].pokemon_bench[0] > 0,
            "Each player must add their pokemon on the bench"
        );

        require(setOpponent(), "Error: setOpponent function");
        require(flipacoin(), "Error: flipacoin function");
        // require(mintPrizeCard(), "Error: mintPrizeCard function");
        isGameStart = true;
        return true;
    }

    // Function to generate a random number based on block properties
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, player_no)));
    }

    // Function to randomly determine the starting player's turn
    function flipacoin() public onlyManager returns (bool) {
        require(current_turn == address(0), "You have already flipped the coin");
        uint index = random() % player_no.length;
        current_turn = player_no[index];
        return true;
    }

    // Function to check if a Pokemon card has the "basic" stage
    function checkPokemonStage(uint _pokemonNftId) private view returns (bool) {
        (,,,,, string memory _stage,,,,) = _pokemon.Pokemon_card_details(_pokemonNftId);
        if (keccak256(abi.encodePacked(_stage)) == keccak256(abi.encodePacked("basic"))) {
            return true;
        } else {
            revert("This is not a basic pokemon type card");
        }
    }

    // Function for players to add an active Pokemon to the game
    function addActivePokemon(uint _activePokemonId) public onlyPlayer {
        require(playerGameSettings[msg.sender].active_pokemon == 0, "Active Pokemon is already added");
        require(checkPokemonStage(_activePokemonId), "Pokemon Stage must be Basic");
        for (uint i = 0; i < players[msg.sender].card_list.length; i++) {
            if (players[msg.sender].card_list[i] == _activePokemonId) {
                playerGameSettings[msg.sender].player_address = msg.sender;
                playerGameSettings[msg.sender].active_pokemon = _activePokemonId;
                (, , uint _currentHp, , , , , , , ) = _pokemon.Pokemon_card_details(
                    playerGameSettings[msg.sender].active_pokemon
                );
                playerGameSettings[msg.sender].current_hp = _currentHp;
                break;
            }
        }
        if (playerGameSettings[msg.sender].active_pokemon == 0) {
            revert("Your active pokemon id is different from your initial pokemon list");
        }
    }

    // Function for players to add Pokemon to the bench
    function addPokemonInBench(uint[5] memory _benchPokemonId) public onlyPlayer {
        require(
            playerGameSettings[msg.sender].pokemon_bench[0] == 0,
            "You already added five pokemon onto the bench"
        );
        uint flag;
        for (uint i = 0; i < 5; i++) {
            for (uint j = 0; j < 6; j++) {
                if (_benchPokemonId[i] == players[msg.sender].card_list[j]) {
                    if (_benchPokemonId[i] != playerGameSettings[msg.sender].active_pokemon) {
                        flag++;
                    } else {
                        revert("Your bench pokemon list consists active pokemon id");
                    }
                }
            }
        }

        if (flag == 5) {
            playerGameSettings[msg.sender].pokemon_bench = _benchPokemonId;
        } else {
            revert("Your bench pokemon ids are different from your initial pokemon list");
        }
    }

    // Function to check ownership of an energy card
    function checkEnergyCardOwnerShip(uint _energyCardId, address _caller) private view returns (bool) {
        if (_pokemon.balanceOf(_caller, _energyCardId) > 0) {
            return true;
        } else {
            return false;
        }
    }

    // Function to check if the player owns the required quantity of an energy card
    function checkEnergyCardQty(uint _energyCardId, uint _quantity, address _caller) private view returns (bool) {
        if (_pokemon.balanceOf(_caller, _energyCardId) >= _quantity) {
            return true;
        } else {
            return false;
        }
    }

    // Function to check if an NFT is of type Energy
    function checkCardTypeEnergy(uint _energyCardId) private view returns (bool) {
        (uint _id, , , ) = _pokemon.Energy_card_details(_energyCardId);
        if (_id > 0) {
            return true;
        } else {
            return false;
        }
    }

    // Function for players to perform an attack using an energy card
    function attack(uint _energyCardId, uint _quantity) public onlyPlayer returns (bool) {
        require(checkCardTypeEnergy(_energyCardId), "Your NFTs is not the energy type");
        require(
            checkEnergyCardOwnerShip(_energyCardId, msg.sender),
            "You are not the owner of this energy card"
        );
        require(
            checkEnergyCardQty(_energyCardId, _quantity, msg.sender),
            "You must own the required quantity of energy card"
        );
        require(isGameStart == true, "This game has not started yet");
        require(msg.sender == current_turn, "This is not your turn. Please wait for your turn");

        (, , , , string memory _activePokemonType, , , , uint _activePokemonQty, ) = _pokemon.Pokemon_card_details(
            playerGameSettings[msg.sender].active_pokemon
        );
        (, , string memory _energyCardName, ) = _pokemon.Energy_card_details(_energyCardId);
        require(
            keccak256(abi.encodePacked(_activePokemonType)) == keccak256(abi.encodePacked(_energyCardName)),
            "You are using different energy for your active pokemon card. Please use the same energy as per your Active Pokemon"
        );
        require(
            _activePokemonQty == _quantity,
            "Your energy card quantity is not equal to the required Active Pokemon Quantity"
        );

        uint result;
        uint opponentCurrentHp = playerGameSettings[playerGameSettings[msg.sender].opponent].current_hp;
        (, , , , , , , , uint activePokemonDamage, ) = _pokemon.Pokemon_card_details(
            playerGameSettings[msg.sender].active_pokemon
        );
        result = opponentCurrentHp - activePokemonDamage;

        if (result <= 0) {
            playerGameSettings[playerGameSettings[msg.sender].opponent].is_knocked[
                playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon
            ] = true;

            for (
                uint i = 0;
                i < playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench.length;
                i++
            ) {
                if (
                    playerGameSettings[playerGameSettings[msg.sender].opponent].is_knocked[
                        playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench[i]
                    ] == false
                ) {
                    playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon = playerGameSettings[
                        playerGameSettings[msg.sender].opponent
                    ].pokemon_bench[i];
                }
            }

            if (
                playerGameSettings[playerGameSettings[msg.sender].opponent].is_knocked[
                    playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon
                ] == true
            ) {
                winner = msg.sender;
                isGameStart = false;
            }

            (, , uint _opponentActivePokemonHp, , , , , , , ) = _pokemon.Pokemon_card_details(
                playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon
            );
            playerGameSettings[playerGameSettings[msg.sender].opponent].current_hp = _opponentActivePokemonHp;
            current_turn = playerGameSettings[msg.sender].opponent;
            return true;
        } else {
            playerGameSettings[playerGameSettings[msg.sender].opponent].current_hp = result;
            current_turn = playerGameSettings[msg.sender].opponent;
            return true;
        }
    }

    // Placeholder function for minting prize cards (needs to be implemented)
    function mintPrizeCard() public onlyManager returns (bool) {
        // TODO: Implement mintPrizeCard logic
    }

    // Function to set opponent players
    function setOpponent() public onlyManager returns (bool) {
        require(
            playerGameSettings[player_no[0]].opponent == address(0) &&
                playerGameSettings[player_no[1]].opponent == address(0),
            "You have already set the opponent for each player"
        );
        playerGameSettings[player_no[0]].opponent = player_no[1];
        playerGameSettings[player_no[1]].opponent = player_no[0];
        return true;
    }
}
