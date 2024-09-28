import hre from "hardhat";

type Config = {
  VaultAddress: string;
  MembershipAddress: string;
  MembershipHookAddress: string;
};

const sepoliaScriptConfig: Config = {
  VaultAddress: "0x7966FE92C59295EcE7FB5D9EfDB271967BFe2fbA",
  MembershipAddress: "",
  MembershipHookAddress: "",
};

const ethereumScriptConfig: Config = {
  VaultAddress: "",
  MembershipAddress: "",
  MembershipHookAddress: "",
};

const configs: Record<string, Config> = {
  ethereum: ethereumScriptConfig,
  sepolia: sepoliaScriptConfig,
};

export const ScriptConfig: Config = configs[hre.network.name];
