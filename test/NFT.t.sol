// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "../src/NFT.sol";

contract NFTTest is Test {
    NFT nft;

    function setUp() public {
        nft = new NFT("Test", "TST", 3e16, address(this), address(this));
    }

    function mintWithFee(address to, uint256 tokenId, address minter, uint256 value) private {
        hoax(minter);
        nft.mint{value: value}(to, tokenId);
    }

    function testMinting(address to, uint256 tokenId, address minter) public {
        console.log(unicode"🔵 It should allow minting with fee");

        vm.assume(tokenId < 10000);
        vm.assume(minter != address(0));
        vm.assume(to.code.length == 0 && to != address(0));
        mintWithFee(to, tokenId, minter, nft.mintFee());

        console.log(unicode"🔵 It should return valid IPFSHash");
        nft.tokenURI(1);
    }

    function testInsufficientFeeError(address to, uint256 tokenId, address minter) public {
        console.log(unicode"🔵 It should catch fee errors");

        uint256 fee = nft.mintFee() - 1;
        vm.expectRevert(abi.encodeWithSelector(IMintFee.InsufficientFee.selector, minter, fee));
        mintWithFee(to, tokenId, minter, fee);
    }

    function testExceededCapError(address to, uint256 tokenId, address minter) public {
        console.log(unicode"🔵 It should catch cap errors");

        // Set cap overriding its storage slot
        vm.store(address(nft), bytes32(uint256(9)), bytes32(uint256(10000)));
        vm.assume(minter != address(0));
        vm.assume(to.code.length == 0 && to != address(0));
        uint256 fee = nft.mintFee();
        vm.expectRevert(abi.encodeWithSelector(IMintCap.ExceededCap.selector, minter));
        mintWithFee(to, tokenId, minter, fee);
    }

    function testSetDefaultRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator,
        address royaltyAdmin,
        uint96 salePrice
    ) public {
        console.log(unicode"🔵 It should allow setting default royalty");

        nft = new NFT("Test", "TST", nft.mintFee(), royaltyAdmin, address(0));
        vm.assume(receiver.code.length == 0 && receiver != address(0));
        vm.assume(feeNumerator <= 1000);
        vm.prank(royaltyAdmin);
        nft.setDefaultRoyalty(receiver, feeNumerator);

        (address _receiver, uint256 _feeNumerator) = nft.royaltyInfo(tokenId, salePrice);
        assertEq(_receiver, receiver);
        assertEq(_feeNumerator, Math.mulDiv(salePrice, feeNumerator, nft.feeDenominator()));
    }

    function testSetTokenRoyalty(
        uint256 tokenId,
        address receiver,
        uint96 feeNumerator,
        address royaltyAdmin,
        uint96 salePrice
    ) public {
        console.log(unicode"🔵 It should allow setting a token royalty");

        nft = new NFT("Test", "TST", nft.mintFee(), royaltyAdmin, address(0));
        vm.assume(receiver.code.length == 0 && receiver != address(0));
        vm.assume(feeNumerator <= 1000);
        vm.prank(royaltyAdmin);
        nft.setTokenRoyalty(tokenId, receiver, feeNumerator);

        (address _receiver, uint256 _feeNumerator) = nft.royaltyInfo(tokenId, salePrice);
        assertEq(_receiver, receiver);
        assertEq(_feeNumerator, Math.mulDiv(salePrice, feeNumerator, nft.feeDenominator()));
    }

    function testTokenURIFailsOnUnexistentID(uint256 tokenId) public {
        console.log(unicode"🔵 It should revert unexistent token ID");

        vm.expectRevert(abi.encodeWithSelector(Heladitos.UnexistentToken.selector, tokenId));
        nft.tokenURI(tokenId);
    }

    function testTokenURIReturnsKnownIPFSHash() public {
        console.log(unicode"🔵 It should return a known IPFSHash");

        uint256 tokenId = 1727260417373953872291778126086077336273179123693563675004320478128047194372;
        mintWithFee(address(1), tokenId, address(this), nft.mintFee());
        string memory tokenURI = nft.tokenURI(1);
        assertEq(tokenURI, "ipfs://QmNbZJK56QAGYH4G8mF4F9Q1t5thuL8ToXom2YFTUsn8eX");
    }
}
