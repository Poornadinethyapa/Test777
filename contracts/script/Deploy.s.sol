// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/MarketFactory.sol";

contract DeployScript is Script {
    function run() external returns (MarketFactory factory) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        factory = new MarketFactory();

        console.log("MarketFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}

