# Installation

```bash
mkdir balancer-custom-hook && cd balancer-custom-hook
yarn add --dev hardhat
npx hardhat init
```

Let’s create the TypeScript project and go through these steps to compile.
The directory tree should be like this.

```bash
# tree
.
├── README.md
├── contracts
├── hardhat.config.ts
├── ignition
├── node_modules
├── package.json
├── test
├── tsconfig.json
└── yarn.lock
```

Remove sample source code

```bash
rm -rf contracts/* ignition/modules/* test/*
```

Install balancer core contracts

```bash
yarn add 'https://gitpkg.vercel.app/balancer/balancer-v3-monorepo/pkg/interfaces?main'
yarn add @openzeppelin/contracts

mkdir -p contracts/lib
curl https://raw.githubusercontent.com/balancer/balancer-v3-monorepo/refs/heads/main/pkg/vault/contracts/BaseHooks.sol  -o contracts/lib/BaseHooks.sol
```

# Build your custom Hook

A hooks contract should inherit the `BaseHooks.sol` abstract contract, which provides a minimal implementation for a hooks contract.

```solidity
// contracts/MyCustomHook.sol

// SPDX-License-Identifier: MIT
import { BaseHooks } from "./lib/BaseHooks.sol";
import {
    HookFlags
} from "@balancer-labs/v3-interfaces/contracts/vault/VaultTypes.sol";

pragma solidity ^0.8.27;

contract MyCustomHook is BaseHooks {
    function getHookFlags()
        public
        view
        override
        returns (HookFlags memory hookFlags)
    {}
}
```

# Compile and update the logic for your Hook

```bash
npx hardhat compile
```

# Deploy your Hook Smart Contract

Next, to deploy the contract we will use a Hardhat Ignition module.

Inside the ignition/modules folder, create a file with the following code:

```typescript
// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CustomHookModule = buildModule("CustomHookModule", (m) => {
  const customHook = m.contract("MyCustomHook", []);
  return { customHook };
});

export default CustomHookModule;
```
