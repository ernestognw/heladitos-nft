// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface IMintFee {
    error InsufficientFee(address buyer, uint256 fee);

    function mintFee() external view returns (uint256);

    function mint(address to, uint256 tokenId) external payable;

    function setMintFee(uint256 mintFee) external;
}
