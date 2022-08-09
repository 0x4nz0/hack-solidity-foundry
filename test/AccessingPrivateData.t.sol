// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AccessingPrivateData.sol";

contract AccessingPrivateDataTest is Test {
    Vault public vault;

    function setUp() public {
        vault = new Vault(bytes32("secret"));
    }

    function testAccessingPrivateData() public {
        bytes32 secret = vm.load(address(vault), bytes32(uint256(2)));
        assertEq(bytes32("secret"), secret);
    }
}
