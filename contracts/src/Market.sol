// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/AggregatorV3Interface.sol";

/**
 * @title Market
 * @notice Core prediction market contract for price predictions
 */
contract Market {
    enum MarketState {
        Open,
        Closed,
        Resolved
    }

    struct Prediction {
        address user;
        uint256 amount;
        bool isAbove; // true if predicting price will be above target
        uint256 timestamp;
    }

    AggregatorV3Interface public priceFeed;
    address public creator;
    uint256 public targetPrice;
    uint256 public endTime;
    MarketState public state;

    uint256 public totalPoolAbove;
    uint256 public totalPoolBelow;
    
    uint256 public winningPool;
    int256 public finalPrice;

    mapping(address => Prediction[]) public predictions;
    address[] public participants;

    event PredictionMade(
        address indexed user,
        uint256 amount,
        bool isAbove,
        uint256 timestamp
    );
    event MarketResolved(uint256 finalPrice, bool outcome);
    event FundsWithdrawn(address indexed user, uint256 amount);

    modifier onlyCreator() {
        require(msg.sender == creator, "Only creator can perform this action");
        _;
    }

    modifier onlyOpen() {
        require(state == MarketState.Open, "Market is not open");
        require(block.timestamp < endTime, "Market has ended");
        _;
    }

    constructor(
        address _priceFeed,
        uint256 _targetPrice,
        uint256 _duration
    ) {
        require(_priceFeed != address(0), "Invalid price feed address");
        require(_targetPrice > 0, "Target price must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");

        priceFeed = AggregatorV3Interface(_priceFeed);
        creator = msg.sender;
        targetPrice = _targetPrice;
        endTime = block.timestamp + _duration;
        state = MarketState.Open;
    }

    /**
     * @notice Make a prediction on the market
     * @param isAbove true if predicting price will be above target, false otherwise
     */
    function predict(bool isAbove) external payable onlyOpen {
        require(msg.value > 0, "Must send ETH to predict");
        
        // Add to participants if first prediction
        if (predictions[msg.sender].length == 0) {
            participants.push(msg.sender);
        }

        predictions[msg.sender].push(
            Prediction({
                user: msg.sender,
                amount: msg.value,
                isAbove: isAbove,
                timestamp: block.timestamp
            })
        );

        if (isAbove) {
            totalPoolAbove += msg.value;
        } else {
            totalPoolBelow += msg.value;
        }

        emit PredictionMade(msg.sender, msg.value, isAbove, block.timestamp);
    }

    /**
     * @notice Resolve the market based on current price feed
     */
    function resolve() external {
        require(
            state == MarketState.Open,
            "Market must be open to resolve"
        );
        require(
            block.timestamp >= endTime,
            "Market has not ended yet"
        );

        state = MarketState.Closed;

        // Get latest price from Chainlink oracle
        (, int256 price, , , ) = priceFeed.latestRoundData();
        require(price > 0, "Invalid price data");

        finalPrice = price;
        bool outcome = uint256(price) >= targetPrice;
        
        if (outcome) {
            winningPool = totalPoolAbove;
        } else {
            winningPool = totalPoolBelow;
        }

        state = MarketState.Resolved;

        emit MarketResolved(uint256(price), outcome);
    }

    /**
     * @notice Withdraw winnings after market is resolved
     */
    function withdraw() external {
        require(state == MarketState.Resolved, "Market must be resolved");
        
        uint256 userTotalWager = 0;
        uint256 userWinningWager = 0;
        bool userWon = finalPrice >= int256(targetPrice);

        // Calculate user's total wager and winning wager
        for (uint256 i = 0; i < predictions[msg.sender].length; i++) {
            Prediction memory pred = predictions[msg.sender][i];
            userTotalWager += pred.amount;
            
            if (pred.isAbove == userWon) {
                userWinningWager += pred.amount;
            }
        }

        require(userWinningWager > 0, "No winnings to withdraw");

        // Calculate payout based on proportional share of winning pool
        uint256 payout = (winningPool * userWinningWager) / 
                         (userWon ? totalPoolAbove : totalPoolBelow);

        // Reset user predictions to prevent double withdrawal
        delete predictions[msg.sender];

        (bool success, ) = payable(msg.sender).call{value: payout}("");
        require(success, "Withdrawal failed");

        emit FundsWithdrawn(msg.sender, payout);
    }

    /**
     * @notice Get user's predictions
     */
    function getUserPredictions(address user)
        external
        view
        returns (Prediction[] memory)
    {
        return predictions[user];
    }

    /**
     * @notice Get total participants count
     */
    function getParticipantsCount() external view returns (uint256) {
        return participants.length;
    }

    /**
     * @notice Get market details
     */
    function getMarketDetails()
        external
        view
        returns (
            uint256 _targetPrice,
            uint256 _endTime,
            MarketState _state,
            uint256 _totalPoolAbove,
            uint256 _totalPoolBelow,
            int256 _finalPrice
        )
    {
        return (
            targetPrice,
            endTime,
            state,
            totalPoolAbove,
            totalPoolBelow,
            finalPrice
        );
    }
}

