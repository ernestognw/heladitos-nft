// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library IPFS {
    bytes internal constant ALPHABET =
        "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

    function toHash(uint256 input) internal pure returns (string memory) {
        bytes memory digits = new bytes(46);
        uint8 length = 0;
        for (uint8 i = 0; i < 34; ++i) {
            uint256 carry;
            if (i == 0) {
                carry = 0x12;
            } else if (i == 1) {
                carry = 0x20;
            } else {
                carry = (input >> (8 * (33 - i))) & 0xFF;
            }
            for (uint256 j = 0; j < length; ++j) {
                carry += uint8(digits[j]) * 256;
                digits[j] = bytes1(uint8(carry % 58));
                carry /= 58;
            }
            while (carry > 0) {
                digits[length++] = bytes1(uint8(carry % 58));
                carry /= 58;
            }
        }
        for (uint8 i = 0; i < 23; ++i) {
            (digits[i], digits[45 - i]) = (
                ALPHABET[uint8(digits[45 - i])],
                ALPHABET[uint8(digits[i])]
            );
        }
        return string(digits);
    }
}
