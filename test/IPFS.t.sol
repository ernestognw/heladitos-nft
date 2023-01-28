// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "../src/IPFS.sol";

contract HeladitosTest is Test {
    function setUp() public {}

    function testIpfsHash() public {
        assertEq(
            IPFS.toHash(1727260417373953872291778126086077336273179123693563675004320478128047194372),
            "QmNbZJK56QAGYH4G8mF4F9Q1t5thuL8ToXom2YFTUsn8eX"
        );
    }

    function testIpfsHashInput(uint256 input) public {
        IPFS.toHash(input);
        assertTrue(true);
    }
}
