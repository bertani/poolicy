var Web3 = require('web3')
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8080'))
var from = web3.eth.coinbase;
web3.eth.defaultAccount = from;



var abi = [ { "constant": false, "inputs": [ { "name": "proof", "type": "bytes" } ], "name": "checkProof", "outputs": [ { "name": "", "type": "bool" } ], "type": "function" }, { "constant": false, "inputs": [ { "name": "_amount", "type": "uint256" } ], "name": "withdrawCollateral", "outputs": [], "type": "function" }, { "constant": false, "inputs": [], "name": "depositCollateral", "outputs": [ { "name": "", "type": "bool" } ], "type": "function" }, { "constant": false, "inputs": [ { "name": "_poolAddr", "type": "address" }, { "name": "_proof", "type": "bytes" } ], "name": "redeemBounty", "outputs": [], "type": "function" }, { "constant": true, "inputs": [], "name": "_match", "outputs": [ { "name": "", "type": "bool" } ], "type": "function" }, { "constant": false, "inputs": [ { "name": "_a", "type": "bytes32" } ], "name": "bytes32_to_bytes", "outputs": [ { "name": "_result", "type": "bytes1[32]" } ], "type": "function" }, { "anonymous": true, "inputs": [ { "indexed": false, "name": "_tbl", "type": "string" } ], "name": "Log", "type": "event" }, { "anonymous": true, "inputs": [ { "indexed": false, "name": "_tbl", "type": "uint256" } ], "name": "Log_uint", "type": "event" }, { "anonymous": true, "inputs": [ { "indexed": false, "name": "_data", "type": "bytes" } ], "name": "Log_data", "type": "event" }, { "anonymous": true, "inputs": [ { "indexed": false, "name": "_data", "type": "uint256[2]" } ], "name": "Log_bytes64", "type": "event" }, { "anonymous": true, "inputs": [ { "indexed": false, "name": "_data", "type": "bytes32" } ], "name": "Log_bytes32", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "_data", "type": "bytes1[32]" } ], "name": "Log_bytes32_", "type": "event" }];

var addr = process.argv[2];
//var proof = process.argv[3];
var proof = "0x01"+"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"+"00"+"57d07d265597efe50a3db3880090adb417ae828530e6a86894bae889b0e34ae9"+"00";
var contract = web3.eth.contract(abi).at(addr);
console.log(contract.checkProof(proof, {gas: 500*1000}));


