// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Market.sol";

/**
 * @title MarketFactory
 * @notice Factory contract for creating prediction markets
 */
contract MarketFactory {
    address[] public markets;
    mapping(address => bool) public isMarket;

    event MarketCreated(
        address indexed market,
        address indexed creator,
        address priceFeed,
        uint256 targetPrice,
        uint256 endTime
    );

    /**
     * @notice Create a new prediction market
     * @param priceFeed Address of Chainlink price feed
     * @param targetPrice Target price for prediction
     * @param duration Duration in seconds until market closes
     * @return market Address of the newly created market
     */
    function createMarket(
        address priceFeed,
        uint256 targetPrice,
        uint256 duration
    ) external returns (address market) {
        Market newMarket = new Market(priceFeed, targetPrice, duration);
        market = address(newMarket);
        markets.push(market);
        isMarket[market] = true;

        emit MarketCreated(
            market,
            msg.sender,
            priceFeed,
            targetPrice,
            block.timestamp + duration
        );
    }

    /**
     * @notice Get all markets created by this factory
     * @return Array of market addresses
     */
    function getAllMarkets() external view returns (address[] memory) {
        return markets;
    }

    /**
     * @notice Get the number of markets created
     * @return Count of markets
     */
    function getMarketsCount() external view returns (uint256) {
        return markets.length;
    }
}

