// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/DOS.sol";

contract DOSTest is Test {
    KingOfEther public kingOfEther;
    
    function setUp() public {
        kingOfEther = new KingOfEther();
    }
    
    function testClaimThrone() public {
        address alice = vm.addr(1);
        hoax(alice);
        kingOfEther.claimThrone{value: 1 ether}();
        
        assertEq(kingOfEther.king(), alice);
        
        address bob = vm.addr(2);
        hoax(bob);
        kingOfEther.claimThrone{value: 2 ether}();
        
        assertEq(kingOfEther.king(), bob);
    }
    
    function testDenialOfService() public {
        address alice = vm.addr(1);
        hoax(alice);
        kingOfEther.claimThrone{value: 1 ether}();
        
        assertEq(kingOfEther.king(), alice);
        
        address bob = vm.addr(2);
        hoax(bob);
        kingOfEther.claimThrone{value: 2 ether}();
        
        assertEq(kingOfEther.king(), bob);
        
        address eve = vm.addr(3);
        hoax(eve);
        Attack attack = new Attack(kingOfEther);
        hoax(eve);
        attack.attack{value: 3 ether}();

        assertEq(kingOfEther.king(), address(attack));
        
        address steve = vm.addr(4);
        hoax(steve);
        vm.expectRevert(bytes("Failed to send Ether"));
        kingOfEther.claimThrone{value: 4 ether}();
    }
}
