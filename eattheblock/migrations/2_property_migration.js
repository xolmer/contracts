// const Property = artifacts.require('Property.sol');
// const FixedSizeArray = artifacts.require('FixedSizeArray.sol');
// const DynamicArray = artifacts.require('DynamicArray.sol');
const ContractAddress = artifacts.require('ContractAddress.sol');

module.exports = function (deployer) {
  // deployer.deploy(Property, 200, 'Paris');
  // deployer.deploy(FixedSizeArray);
  // deployer.deploy(DynamicArray);
  deployer.deploy(ContractAddress);
};
