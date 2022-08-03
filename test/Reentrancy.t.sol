// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Reentrancy.sol";

contract ReentrancyTest is Test {
	EtherStore public etherStore;
	
    function setUp() public {
    	etherStore = new EtherStore();
    	
    	address alice = vm.addr(1);
    	hoax(alice);
    	etherStore.deposit{value: 1 ether}();
    	
    	address bob = vm.addr(2);
    	hoax(bob);
    	etherStore.deposit{value: 1 ether}();
    }

    function testAttack() public {
        address eve = vm.addr(3);
        hoax(eve);
        
        Attack attack =  new Attack(address(etherStore));
        attack.attack{value: 1 ether}();
        
        assertEq(attack.getBalance(), 3 ether);
    }
}
