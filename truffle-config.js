const path = require("path");

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      // gas: 2000000
    }
  }
};
