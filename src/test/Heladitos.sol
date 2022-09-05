// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "../Heladitos.sol";

contract HeladitosTest is Test {
    Heladitos heladitos;

    function setUp() public {
        heladitos = new Heladitos("Test", "TST");
    }

    function testTokenURIFailsOnInexistentID(uint256 id) public {
        vm.expectRevert(bytes("ERC721: URI query for nonexistent token"));
        heladitos.tokenURI(id);
    }

    function testTokenURIReturnsIPFSHash() public {
        uint256 id = 1727260417373953872291778126086077336273179123693563675004320478128047194372;
        heladitos.mint(address(1), id);
        string memory tokenURI = heladitos.tokenURI(id);
        assertEq(tokenURI, "ipfs://QmNbZJK56QAGYH4G8mF4F9Q1t5thuL8ToXom2YFTUsn8eX");
    }
}
