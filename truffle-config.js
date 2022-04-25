var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "element melody noble youth mechanic dash core outdoor blind spice relax vital";

module.exports = {
  networks: {
    
     rinkeby:{
      provider: function() { 
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/7ad96ad726c84dd28db9b7428e1e2be5", 1);
       },
      network_id: 4,
      gas: "4500000"
     }
  },
    
     contracts_directory: './src/contracts/',
     contracts_build_directory: './src/abis',


  compilers: {
    solc: {
      version: "^0.8.7",    
        optimizer: {
          enabled: true,
          runs: 200
        },
    }
  },
};
