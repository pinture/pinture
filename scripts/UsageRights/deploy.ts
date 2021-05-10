import { Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";

async function main(): Promise<void> {

  // We get the contract to deploy
  const Photo: ContractFactory = await ethers.getContractFactory("PhotoToken");
  const photo: Contract = await Photo.deploy();
  await photo.deployed();

  console.log("Photo deployed to: ", photo.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
