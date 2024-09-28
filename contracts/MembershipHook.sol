// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.27;

import { BaseHooks } from "./lib/BaseHooks.sol";
import {
    HookFlags,
    TokenConfig,
    LiquidityManagement,
    AddLiquidityKind,
    RemoveLiquidityKind,
    PoolSwapParams
} from "@balancer-labs/v3-interfaces/contracts/vault/VaultTypes.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IMembershipHook} from "./interfaces/IMembershipHook.sol";
import {VaultGuard} from "./lib/VaultGuard.sol";
import { IVault } from "@balancer-labs/v3-interfaces/contracts/vault/IVault.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import {IMembership} from "./interfaces/IMembership.sol";
import { IRouterCommon } from "@balancer-labs/v3-interfaces/contracts/vault/IRouterCommon.sol";

contract MembershipHook is BaseHooks, IMembershipHook, VaultGuard, Ownable {
    IMembership private _membershipToken;
    mapping(uint256 => uint256) private _membershipFee;
    mapping(uint256 => uint256) private _tierFeeBps;

    /**
     * @notice A new `MembershipHook` contract has been registered successfully for a given factory and pool.
     * @dev If the registration fails the call will revert, so there will be no event.
     * @param hooksContract This contract
     * @param pool The pool on which the hook was registered
     */
    event MembershipHookRegistered(address indexed hooksContract, address indexed pool);

    constructor(IVault vault, address membershipToken) VaultGuard(vault) Ownable(msg.sender) {
        _membershipToken = IMembership(membershipToken);

        _tierFeeBps[0] = 16e13;  // 0.0016%
        _tierFeeBps[1] = 8e12;  // 0.0008%
        _tierFeeBps[2] = 4e12;  // 0.0004%
        _tierFeeBps[3] = 2e12;  // 0.0002%
        _tierFeeBps[4] = 1e12;  // 0.0001%
    }

    /// @inheritdoc BaseHooks
    function getHookFlags()
        public
        pure
        override
        returns (HookFlags memory hookFlags)
    {
        hookFlags.shouldCallComputeDynamicSwapFee = true;
    }

    /// @inheritdoc BaseHooks
    function onRegister(
        address factory,
        address poolAddress,
        TokenConfig[] memory,
        LiquidityManagement calldata
    ) public override onlyVault returns (bool) {
        emit MembershipHookRegistered(address(this), poolAddress);
        return true;
    }

    /// @inheritdoc BaseHooks
    function onComputeDynamicSwapFeePercentage(
        PoolSwapParams calldata params,
        address pool,
        uint256 staticSwapFeePercentage
    ) public view override onlyVault returns (bool, uint256) {
        address user = IRouterCommon(params.router).getSender();

        // Get fee based on membership level
        uint256 level = _membershipToken.getTierLevel(user);

        // Charge the static or calculated fee, whichever is greater.
        return (
            true,
            _tierFeeBps[level]
        );
    }

    function setTierPrice(uint256 tier, uint256 feeBps) external onlyOwner {
        _tierFee[tier] = feeBps;
    }
}