// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "./abstract/Heladitos.sol";
import "./IPFS.sol";

contract NFT is Heladitos {
    uint256 private _tokenId;
    uint256 private _mintFee;

    mapping(uint256 => uint256) tokenIdToCid;

    bytes32 public constant ROYALTY_SETTER = keccak256("ROYALTY_SETTER");
    bytes32 public constant MINT_FEE_SETTER = keccak256("MINT_FEE_SETTER");

    constructor(
        string memory name,
        string memory symbol,
        uint256 initialMintFee,
        address initialRoyaltyAdmin,
        address initialFeeSetter
    ) ERC721(name, symbol) {
        _mintFee = initialMintFee;

        _setRoleAdmin(ROYALTY_SETTER, ROYALTY_SETTER);
        _setRoleAdmin(MINT_FEE_SETTER, ROYALTY_SETTER);

        _grantRole(ROYALTY_SETTER, initialRoyaltyAdmin);
        _grantRole(MINT_FEE_SETTER, initialFeeSetter);
    }

    function feeDenominator() public view virtual override returns (uint256) {
        return _feeDenominator();
    }

    function mintFee() public view virtual override returns (uint256) {
        return _mintFee;
    }

    function mint(address to, uint256 cid) external payable override {
        if (msg.value < mintFee()) revert InsufficientFee(_msgSender(), msg.value);
        if (_tokenId >= 10000) revert ExceededCap(_msgSender());
        _safeMint(to, ++_tokenId);
        tokenIdToCid[_tokenId] = cid;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert UnexistentToken(tokenId);
        return string(bytes.concat("ipfs://", bytes(IPFS.toHash(tokenIdToCid[tokenId]))));
    }

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) public override onlyRole(ROYALTY_SETTER) {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function deleteDefaultRoyalty() public override onlyRole(ROYALTY_SETTER) {
        _deleteDefaultRoyalty();
    }

    function setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator)
        public
        override
        onlyRole(ROYALTY_SETTER)
    {
        _setTokenRoyalty(tokenId, receiver, feeNumerator);
    }

    function resetTokenRoyalty(uint256 tokenId) public override onlyRole(ROYALTY_SETTER) {
        _resetTokenRoyalty(tokenId);
    }

    function setMintFee(uint256 newMintFee) external virtual override onlyRole(MINT_FEE_SETTER) {
        _mintFee = newMintFee;
    }
}
