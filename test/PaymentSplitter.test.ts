import { ethers } from 'hardhat'
import { expect } from 'chai'
import { Contract, Signer } from 'ethers'

describe('PaymentSplitter', () => {
  let PaymentSplitter: Contract
  let owner: Signer
  let signers: Signer[]

  beforeEach(async () => {
    const PaymentSplitterFactory = await ethers.getContractFactory('PaymentSplitter')
    ;[owner, ...signers] = await ethers.getSigners()
    PaymentSplitter = await PaymentSplitterFactory.deploy()
  })

  it('Should receive funds', async () => {
    await owner.sendTransaction({ to: PaymentSplitter.address, value: ethers.utils.parseEther('1') })
    expect(await ethers.provider.getBalance(PaymentSplitter.address)).to.equal(ethers.utils.parseEther('1'))
  })

  it('Should set receivers correctly', async () => {
    const basisPoints = [5000, 3000, 2000]
    const addresses = await Promise.all(signers.slice(0, basisPoints.length).map(async (signer) => signer.getAddress()))

    await PaymentSplitter.connect(owner).setReceivers(addresses, basisPoints)

    const storedReceivers = []
    for (let i = 0; i < addresses.length; i++) {
      storedReceivers.push(await PaymentSplitter.receivers(i))
    }

    expect(storedReceivers).to.deep.equal(addresses.map((addr, i) => ([ addr, basisPoints[i] ])))
  })

  it('Should fail to set receivers with invalid basis points', async () => {
    const basisPoints = [5000, 4000, 2000]
    const addresses = await Promise.all(signers.slice(0, basisPoints.length).map(async (signer) => signer.getAddress()))

    await expect(PaymentSplitter.connect(owner).setReceivers(addresses, basisPoints)).to.be.revertedWith('Total basis points must equal 10000')
  })

  it('Should split and withdraw funds correctly', async () => {
    const basisPoints = [5000, 3000, 2000]
    const addresses = await Promise.all(signers.slice(0, basisPoints.length).map(async (signer) => signer.getAddress()))
    await PaymentSplitter.connect(owner).setReceivers(addresses, basisPoints)

    await owner.sendTransaction({ to: PaymentSplitter.address, value: ethers.utils.parseEther('1') })

    const initialBalances = await Promise.all(addresses.map(async (addr) => ethers.provider.getBalance(addr)))
    await PaymentSplitter.connect(owner).withdraw()

    const expectedAmounts = basisPoints.map((bp) => ethers.utils.parseEther('1').mul(bp).div(10000))
    const finalBalances = await Promise.all(addresses.map(async (addr) => ethers.provider.getBalance(addr)))

    finalBalances.forEach((balance, i) => {
      expect(balance).to.equal(initialBalances[i].add(expectedAmounts[i]))
    })

    expect(await ethers.provider.getBalance(PaymentSplitter.address)).to.equal(0)
  })
})
