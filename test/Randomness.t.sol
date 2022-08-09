// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Randomness.sol";

contract RandomnessTest is Test {
    GuessTheRandomNumber public guessTheRandomNumber;

    function setUp() public {
        address alice = vm.addr(1);
        hoax(alice);
        guessTheRandomNumber = new GuessTheRandomNumber{value: 1 ether}();
    }

    function testGuessTheRandomNumber() public {
        assertEq(address(guessTheRandomNumber).balance, 1 ether);

        address eve = vm.addr(3);
        startHoax(eve);

        Attack attack = new Attack();
        attack.attack(guessTheRandomNumber);

        assertEq(address(guessTheRandomNumber).balance, 0 ether);
        assertEq(address(attack).balance, 1 ether);
    }
}
