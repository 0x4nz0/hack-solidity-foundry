// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ForceEther.sol";

contract ForceEtherTest is Test {
    EtherGame public etherGame;

    function setUp() public {
        etherGame = new EtherGame();

        address alice = vm.addr(1);
        hoax(alice);
        etherGame.deposit{value: 1 ether}();

        address bob = vm.addr(2);
        hoax(bob);
        etherGame.deposit{value: 1 ether}();
    }
    
    function testClaimReward() public {
        address eve = vm.addr(3);
        startHoax(eve);

        for (uint256 i = 0; i < 5; i++) {
            etherGame.deposit{value: 1 ether}();
        }

        assertEq(address(etherGame).balance, 7 ether);
        assertEq(etherGame.winner(), eve);
        
        etherGame.claimReward();
    }

    function testCannotClaimReward() public {
        address eve = vm.addr(3);
        startHoax(eve);

        Attack attack = new Attack(etherGame);
        attack.attack{value: 5 ether}();

        assertEq(address(etherGame).balance, 7 ether);
        
        vm.expectRevert(bytes("Not winner"));
        etherGame.claimReward();
    }
}
