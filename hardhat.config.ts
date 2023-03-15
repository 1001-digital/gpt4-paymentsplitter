import { HardhatUserConfig } from 'hardhat/config'
import { config as dotenvConfig } from 'dotenv'
import "@nomicfoundation/hardhat-toolbox"
import '@nomiclabs/hardhat-etherscan'
import 'hardhat-gas-reporter'
import 'solidity-coverage'

dotenvConfig()

const {
  COINMARKETCAP_API_KEY,
  ETHERSCAN_API_KEY,
  GOERLI_URL ,
  MAINNET_URL,
  PRIVATE_KEY,
  REPORT_GAS,
} = process.env

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.19',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    goerli: {
      url: GOERLI_URL || "",
      accounts:
        PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
    mainnet: {
      url: MAINNET_URL || "",
      accounts:
        PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
    // Add more networks here if needed, e.g., testnets or mainnets
  },
  gasReporter: {
    enabled: REPORT_GAS !== undefined,
    coinmarketcap: COINMARKETCAP_API_KEY,
    currency: "USD",
    // gasPrice: 20,
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
}

export default config
