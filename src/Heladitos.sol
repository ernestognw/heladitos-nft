// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Heladitos is ERC721 {
    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mint(address to, uint256 tokenId) public {
        _safeMint(to, tokenId);
    }
}
