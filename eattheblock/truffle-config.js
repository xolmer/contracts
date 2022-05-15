const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
module.exports = {
  networks: {
    loc_xolmerganache_xolmerganache: {
      network_id: '5777',
      port: 4646,
      host: '127.0.0.1',
    },
    inf_contractpractice_rinkeby: {
      network_id: 4,
      gasPrice: 10000000000,
      provider: new HDWalletProvider(
        fs.readFileSync(
          '/Users/xolmer/code/config-contract/Untitled.env',
          'utf-8'
        ),
        'https://rinkeby.infura.io/v3/ad2194a7322344a5918d3a1ac6116e73'
      ),
    },
    loc_development_development: {
      network_id: '*',
      port: 7545,
      host: '127.0.0.1',
    },
  },
  mocha: {},
  compilers: {
    solc: {
      version: '0.8.13',
    },
  },
};
