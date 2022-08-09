// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Phishing.sol";

contract PhishingTest is Test {
    Wallet public wallet;

    function setUp() public {
        address alice = vm.addr(1);
        hoax(alice);
        wallet = new Wallet{value: 10 ether}();
    }

    function testTransfer() public {
        address bob = vm.addr(2);
        address alice = vm.addr(1);
        vm.prank(alice, alice);
        wallet.transfer(payable(bob), 1 ether);
    }

    function testCannotTransfer() public {
        address bob = vm.addr(2);
        address eve = vm.addr(3);
        vm.prank(eve, eve);
        vm.expectRevert("Not owner");
        wallet.transfer(payable(bob), 1 ether);
    }

    function testPhishing() public {
        assertEq(address(wallet).balance, 10 ether);

        address eve = vm.addr(3);
        vm.prank(eve);
        Attack attack = new Attack(wallet);

        address alice = vm.addr(1);
        startHoax(alice, alice);
        vm.expectCall(
            address(wallet),
            abi.encodeCall(wallet.transfer, (attack.owner(), 10 ether))
        );
        attack.attack();

        assertEq(address(wallet).balance, 0 ether);
    }
}
