const hre = require("hardhat");

async function main() {
  // Deploying JDAI.sol
  const JDAI = await hre.ethers.getContractFactory("JDAI");
  const jdai = await JDAI.deploy(); // Add constructor parameters if any

  await jdai.deployed();

  console.log("JDAI deployed to:", jdai.address);

  // Deploying TokenFaucet.sol
  const TokenFaucet = await hre.ethers.getContractFactory("TokenFaucet");
  const tokenFaucet = await TokenFaucet.deploy(
    jdai.address, // Assuming TokenFaucet's constructor takes JDAI's address, amountPerClaim, and cooldownPeriod
    hre.ethers.utils.parseUnits("10", 18), // "10" is the amount per claim, modify as per your requirement
    3600 // Cooldown period in seconds, modify as per your requirement
  );

  await tokenFaucet.deployed();

  console.log("TokenFaucet deployed to:", tokenFaucet.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
