const expect = require('chai').expect
const Xamxam = artifacts.require('Xamxam')
const utils = require('./utils')
const BigNumber = web3.BigNumber

const TOTAL_SUPPLY = 2100000000000000
const ADDRESS = '0x50Ebe9ad50DCf1Be1A35570E29587fa9F6eCDB46'

let xamxam = null
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