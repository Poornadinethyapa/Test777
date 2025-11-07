.PHONY: install test build deploy clean

install:
	forge install foundry-rs/forge-std --no-commit
	forge install OpenZeppelin/openzeppelin-contracts --no-commit
	forge install smartcontractkit/chainlink --no-commit

test:
	forge test -vvv

build:
	forge build

deploy-sepolia:
	forge script script/Deploy.s.sol:DeployScript --rpc-url sepolia --broadcast --verify

deploy-mainnet:
	forge script script/Deploy.s.sol:DeployScript --rpc-url mainnet --broadcast --verify

clean:
	forge clean

