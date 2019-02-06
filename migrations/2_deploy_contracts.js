var ICO = artifacts.require("./ICO.sol");
var Token = artifacts.require("./Token.sol");

module.exports = async function (deployer) {
  await deployer.deploy(Token, "FahadToken", "FTK", 6, 100);
  await deployer.deploy(ICO, Token.address);


  // deployer.deploy(Token, 'FahadToken', 'FTK', 6, 100).then(() => {
  //   deployer.deploy(ICO, Token.address);
  // });
  // await deployer.deploy(TOKEN, 'FahadToken', 'FTK', 6, 100);
};
