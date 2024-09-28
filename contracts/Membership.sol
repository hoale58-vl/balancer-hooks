// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./interfaces/IMembership.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Membership is ERC721, IMembership, AccessControl {
    using Strings for uint256;

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(address => uint256) private _tier;
    mapping(uint256 => uint256) private _tierPrice;
    string private baseURI;

    event Purchased(address to, uint256 tier, uint256 price);

    constructor(string memory baseURI_) ERC721("BMembership", "BMEMBER") {
        baseURI = baseURI_;

        _grantRole(ADMIN_ROLE, msg.sender);

        // Default tierPrice in ETH
        _tierPrice[1] = 100 gwei;
        _tierPrice[2] = 1000 gwei;
        _tierPrice[3] = 10000 gwei;
        _tierPrice[4] = 100000 gwei;
    }

    function purchase(address to, uint256 tier) payable public {
        require(msg.value >= _tierPrice[tier], "not enough balance");
        
        if (_tier[to] == 0) {
            uint256 tokenId = uint256(uint160(to));
            _safeMint(to, tokenId);
        } else {
            // Upgrade
            require(_tier[to] < tier, "not upgrade");
        }
        _tier[to] = tier;

        emit Purchased(to, tier, msg.value);
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only the owner of the token can burn it.");
        _burn(tokenId);
    }

    /**
     * @dev Internal function to handle token transfers.
     * Restricts the transfer of Soulbound tokens.
     */
    function _update(address to, uint256 tokenId, address auth)
        internal
        override
        returns (address)
    {
        address from = _ownerOf(tokenId);
        if (from != address(0) && to != address(0)) {
            revert("Soulbound: Transfer failed");
        }

        return super._update(to, tokenId, auth);
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function getTierLevel(address user) external override returns (uint256) {
        return _tier[user];
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setTierPrice(uint256 tier, uint256 price) external onlyRole(ADMIN_ROLE) {
        _tierPrice[tier] = price;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireOwned(tokenId);
        uint256 tier = _tier[address(uint160(tokenId))];

        return string.concat(baseURI, tier.toString());
    }
}