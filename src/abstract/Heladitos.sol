// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {ERC721Errors} from "../common/EIP-6093.sol";
import {IMintFee} from "../interfaces/IMintFee.sol";
import {IMintCap} from "../interfaces/IMintCap.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

abstract contract Heladitos is IMintCap, IMintFee, ERC721Royalty, AccessControl, ERC721Errors {
    error UnexistentToken(uint256 tokenId);

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Royalty, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function feeDenominator() external view virtual returns (uint256);

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) external virtual;

    function deleteDefaultRoyalty() external virtual;

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) external virtual;

    function resetTokenRoyalty(uint256 tokenId) external virtual;
}
