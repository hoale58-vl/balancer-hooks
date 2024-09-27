// SPDX-License-Identifier: MIT

import { BaseHooks } from "./lib/BaseHooks.sol";
import {
    HookFlags
} from "@balancer-labs/v3-interfaces/contracts/vault/VaultTypes.sol";

pragma solidity ^0.8.27;

contract TWMMAHook is BaseHooks {
    function getHookFlags()
        public
        view
        override
        returns (HookFlags memory hookFlags)
    {}
}