// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const TWMMAModule = buildModule("TWMMAModule", (m) => {
  const twmmaHook = m.contract("TWMMAHook", []);
  return { twmmaHook };
});

export default TWMMAModule;
