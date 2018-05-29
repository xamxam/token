require('dotenv').config()
const HDWalletProvider = require("truffle-hdwallet-provider")

module.exports = {
  solc: {
    optimizer: {
        enabled: true,
        runs: 200
    }
  },
  networks: {
    development: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "*"
  },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(process.env.MNEMONIC, process.env.INFURA)
      },
      gas: 4700000,
      gasPrice: 5000000000,
      network_id: 1
    }
  }
}