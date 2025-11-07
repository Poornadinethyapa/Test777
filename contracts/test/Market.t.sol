// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Market.sol";
import "../src/MarketFactory.sol";
import "../src/interfaces/AggregatorV3Interface.sol";

// Mock price feed for testing
contract MockPriceFeed is AggregatorV3Interface {
    int256 public price;
    uint8 public constant decimals = 8;
    uint256 public roundId = 1;

    function setPrice(int256 _price) external {
        price = _price;
        roundId++;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256 answer,
            uint256,
            uint256 updatedAt,
            uint80
        )
    {
        return (uint80(roundId), price, block.timestamp, block.timestamp, uint80(roundId));
    }

    function getRoundData(uint80)
        external
        view
        returns (
            uint80,
            int256 answer,
            uint256,
            uint256 updatedAt,
            uint80
        )
    {
        return (uint80(roundId), price, block.timestamp, block.timestamp, uint80(roundId));
    }

    function decimals() external pure returns (uint8) {
        return 8;
    }

    function description() external pure returns (string memory) {
        return "Mock ETH/USD Price Feed";
    }

    function version() external pure returns (uint256) {
        return 1;
    }
}

contract MarketTest is Test {
    MarketFactory public factory;
    Market public market;
    MockPriceFeed public priceFeed;

    uint256 public constant TARGET_PRICE = 2000 * 1e8; // $2000 with 8 decimals
    uint256 public constant DURATION = 1 days;

    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        priceFeed = new MockPriceFeed();
        priceFeed.setPrice(int256(TARGET_PRICE));

        factory = new MarketFactory();
        address marketAddress = factory.createMarket(
            address(priceFeed),
            TARGET_PRICE,
            DURATION
        );
        market = Market(marketAddress);
    }

    function testCreateMarket() public {
        assertEq(address(market.priceFeed()), address(priceFeed));
        assertEq(market.targetPrice(), TARGET_PRICE);
        assertEq(market.state(), Market.MarketState.Open);
    }

    function testMakePrediction() public {
        vm.prank(alice);
        market.predict{value: 1 ether}(true);

        Market.Prediction[] memory predictions = market.getUserPredictions(alice);
        assertEq(predictions.length, 1);
        assertEq(predictions[0].amount, 1 ether);
        assertEq(predictions[0].isAbove, true);
        assertEq(market.totalPoolAbove(), 1 ether);
    }

    function testMultiplePredictions() public {
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);

        vm.prank(alice);
        market.predict{value: 2 ether}(true);

        vm.prank(bob);
        market.predict{value: 3 ether}(false);

        assertEq(market.totalPoolAbove(), 2 ether);
        assertEq(market.totalPoolBelow(), 3 ether);
        assertEq(market.getParticipantsCount(), 2);
    }

    function testResolveMarketAbove() public {
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);

        vm.prank(alice);
        market.predict{value: 2 ether}(true);

        vm.prank(bob);
        market.predict{value: 3 ether}(false);

        // Set price above target
        priceFeed.setPrice(int256(TARGET_PRICE + 100 * 1e8));

        // Fast forward time
        vm.warp(block.timestamp + DURATION + 1);

        market.resolve();

        assertEq(market.state(), Market.MarketState.Resolved);
        assertEq(market.winningPool(), 2 ether);
        assertGt(uint256(market.finalPrice()), TARGET_PRICE);
    }

    function testResolveMarketBelow() public {
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);

        vm.prank(alice);
        market.predict{value: 2 ether}(true);

        vm.prank(bob);
        market.predict{value: 3 ether}(false);

        // Set price below target
        priceFeed.setPrice(int256(TARGET_PRICE - 100 * 1e8));

        // Fast forward time
        vm.warp(block.timestamp + DURATION + 1);

        market.resolve();

        assertEq(market.state(), Market.MarketState.Resolved);
        assertEq(market.winningPool(), 3 ether);
        assertLt(uint256(market.finalPrice()), TARGET_PRICE);
    }

    function testWithdrawWinnings() public {
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);

        vm.prank(alice);
        market.predict{value: 2 ether}(true);

        vm.prank(bob);
        market.predict{value: 3 ether}(false);

        // Set price above target (alice wins)
        priceFeed.setPrice(int256(TARGET_PRICE + 100 * 1e8));

        vm.warp(block.timestamp + DURATION + 1);
        market.resolve();

        uint256 aliceBalanceBefore = alice.balance;
        vm.prank(alice);
        market.withdraw();

        // Alice should get back her wager plus proportional share of losing pool
        assertGt(alice.balance, aliceBalanceBefore);
    }

    function testFailPredictAfterEndTime() public {
        vm.warp(block.timestamp + DURATION + 1);
        market.predict{value: 1 ether}(true);
    }

    function testFailResolveBeforeEndTime() public {
        market.resolve();
    }

    function testFailWithdrawBeforeResolve() public {
        vm.deal(alice, 10 ether);
        vm.prank(alice);
        market.predict{value: 1 ether}(true);
        market.withdraw();
    }
}

