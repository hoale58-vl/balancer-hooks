import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";
import "hardhat-abi-exporter";
import "hardhat-gas-reporter";
import "@nomiclabs/hardhat-ethers";

dotenv.config();

const { SEPOLIA_TESTNET_PRIVATE_KEY: sepoliaTestnetPrivateKey } = process.env;

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.27",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  gasReporter: {
    enabled: true,
  },
  networks: {
    sepolia: {
      url: "https://eth-sepolia.api.onfinality.io/public",
      chainId: 11155111,
      gasPrice: 5000000000,
      accounts: [sepoliaTestnetPrivateKey!],
      timeout: 2_147_483_647,
    },
  },
  abiExporter: {
    path: "data/abi",
    runOnCompile: true,
    clear: true,
    flat: true,
    only: [],
    spacing: 4,
  },
};

export default config;
