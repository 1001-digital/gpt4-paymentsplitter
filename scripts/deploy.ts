// scripts/deploy.js
const hre = require('hardhat')

async function main() {
  const [deployer] = await hre.ethers.getSigners()

  console.log('Deploying contracts with the account:', deployer.address)
  console.log('Account balance:', (await deployer.getBalance()).toString())

  const PaymentSplitterFactory = await hre.ethers.getContractFactory('PaymentSplitter')
  const PaymentSplitter = await PaymentSplitterFactory.deploy()

  await PaymentSplitter.deployed()

  console.log('PaymentSplitter deployed to:', PaymentSplitter.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
