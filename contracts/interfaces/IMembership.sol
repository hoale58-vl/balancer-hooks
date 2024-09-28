// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IMembership is IERC721 {
    function getTierLevel(address user) external returns (uint256);
}
