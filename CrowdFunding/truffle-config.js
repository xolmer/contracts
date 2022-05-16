module.exports = {
  networks: {
    loc_xolmerganache_xolmerganache: {
      network_id: '*',
      port: 4646,
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
