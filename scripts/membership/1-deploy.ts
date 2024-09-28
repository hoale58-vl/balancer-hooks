import "@nomiclabs/hardhat-ethers";
import { ethers } from "hardhat";
import { ScriptConfig } from "./config";

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account: ", owner.address);

  const Membership = await ethers.getContractFactory("Membership");
  const membership = await Membership.deploy("https://");
  console.log("Membership NFT is deployed at: ", membership.getAddress());

  const MembershipHook = await ethers.getContractFactory("MembershipHook");
  const membershipHook = await MembershipHook.deploy(
    ScriptConfig.VaultAddress,
    membership.getAddress()
  );
  console.log("MembershipHook is deployed at: ", membershipHook.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
