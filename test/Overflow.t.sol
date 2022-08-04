// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "forge-std/Test.sol";
import "../src/Overflow.sol";

contract OverflowTest is Test {
	TimeLock public timeLock;
	
    function setUp() public {
    	timeLock = new TimeLock();
    }
    
    function testCannotWithdraw() public {
        address alice = vm.addr(1);
        startHoax(alice);
        
        timeLock.deposit{value: 1 ether}();
        
        vm.expectRevert(bytes("Lock time not expired"));
        timeLock.withdraw();
    }

    function testAttack() public {
        address eve = vm.addr(3);
        startHoax(eve);
        
        Attack attack =  new Attack(timeLock);
        attack.attack{value: 1 ether}();
        
        assertEq(timeLock.lockTime(eve), 0);
    }
}
