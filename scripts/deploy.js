// scripts/deploy.js
const hre = require("hardhat");

async function main() {
  // Compile contracts if not compiled
  await hre.run('compile');

  // Get the ContractFactory and deploy
  const Crowdfunding = await hre.ethers.getContractFactory("CrowdfundingPlatform");

  // Deploy with constructor parameters (goal, duration in seconds)
  const goalInWei = hre.ethers.utils.parseEther("1"); // 1 ETH
  const duration = 7 * 24 * 60 * 60; // 7 days

  const crowdfunding = await Crowdfunding.deploy(goalInWei, duration);

  await crowdfunding.deployed();

  console.log(`Contract deployed to: ${crowdfunding.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
