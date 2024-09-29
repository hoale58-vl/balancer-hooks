import "@nomicfoundation/hardhat-ethers";
import { ethers } from "hardhat";
import { ScriptConfig } from "./config";

async function main() {
  const [owner] = await ethers.getSigners();
  console.log("Deploying contracts with the account: ", owner.address);

  const Membership = await ethers.getContractFactory("Membership");
  const membership = await Membership.deploy(
    "https://raw.githubusercontent.com/hoale58-vl/balancer-hooks/refs/heads/master/data/membership/"
  );
  const membershipAddr = await membership.getAddress();
  console.log("Membership NFT is deployed at: ", membershipAddr);

  const MembershipHook = await ethers.getContractFactory("MembershipHook");
  const membershipHook = await MembershipHook.deploy(
    ScriptConfig.VaultAddress,
    membershipAddr
  );
  console.log(
    "MembershipHook is deployed at: ",
    await membershipHook.getAddress()
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
