# PaymentSplitter

A simple Solidity smart contract that allows splitting received funds among multiple receivers according to their basis points.

Note: This was an experiment in conversational programming with GPT-4. All code is generated by GPT. You can read the entire conversatioin by opening the `conversation.mht` file in the project root.


## Features

- Receive funds sent to the contract
- Set payment receivers with basis points
- Withdraw the entire balance stored in the contract and split it among the receivers according to their basis points
- Only the contract owner can set receivers and call the withdraw function


## Getting Started


### Prerequisites

- [Node.js](https://nodejs.org/en/) (v14.x or later)
- [Yarn](https://yarnpkg.com/) (optional, but recommended)
- [Hardhat](https://hardhat.org/getting-started/) (for development and testing)

### Installation

1. Clone the repository: `git clone https://github.com/your-username/payment-splitter.git`
2. Change to the project directory: `cd payment-splitter`
3. Install dependencies: `yarn`


### Deployment

To deploy the contract to a local development network, run: `npx hardhat run scripts/deploy.js --network localhost`


### Testing

To run the tests, execute the following command: `npx hardhat test`


## Built With

- [Solidity](https://soliditylang.org/) - The smart contract programming language
- [Hardhat](https://hardhat.org/) - The development and testing framework
- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts) - For reusable smart contract components


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
