const expect = require('chai').expect
const Xamxam = artifacts.require('Xamxam')
const utils = require('./utils')
const BigNumber = web3.BigNumber

const TOTAL_SUPPLY = 100000000000000000000000000000000
const ADDRESS = '0x627306090abab3a6e1400e9345bc60c78a8bef57'

let xam = null
let accounts = null
let transfer_event = null
let owner = null
let owner_balance = null
let acct_one = null
let starting_balance_one = null
let ending_balance_one = null
let acct_two = null
let starting_balance_two = null
let ending_balance_two = null
let acct_three = null

contract('Xamxam ERC20 Token Tests', async (accounts) => {

    beforeEach(async () => {
        xam = await Xamxam.deployed()
    })
  
    it('should fail because the function doest not exist in Contract', async () => {
      try {
        await xam.nonExistentFunction()
      } catch (error) {
        expect(error.name).to.equal('TypeError')
        return true
      }
      throw new Error('I should never see this!')
    })
  
    it('contract should be owned by the correct address', async () => {
      owner = await xam.owner.call()
      expect(owner.valueOf()).to.equal(ADDRESS)
    })
  
    it('should initialize the contract with the name Xamxam', async () => {
      const name = await xam.name.call()
      expect(name.valueOf()).to.equal('Xamxam')
    })
  
    it('should have the token symbol XAM', async () => {
      const symbol = await xam.symbol.call()
      expect(symbol.valueOf()).to.equal('XAM')
    })
  
    it('should have 18 decimals places', async () => {
      const decimals = (await xam.decimals.call()).toNumber()
      expect(decimals.valueOf()).to.equal(18)
    })
  
    it('a random account should not hold any tokens at initialization', async () => {
      random_acct = accounts[8]
      starting_balance_one = (await xam.balanceOf(random_acct)).toNumber()
      expect(starting_balance_one).to.equal(0)
    })
  
    it('should not allow a non-owner transfer of ownership', async () => {
      acct_two = accounts[1]
      await utils.assertRevert(xam.transferOwnership(acct_two, {from: acct_two}))
    })
  
})
  