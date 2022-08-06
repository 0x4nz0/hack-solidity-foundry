// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/UnsafeDelegatecall.sol";

contract UnsafeDelegatecallTest is Test {
    Lib public lib;
    HackMe public hackMe;
    
    function setUp() public {
        address alice = vm.addr(1);
        
        hoax(alice);
        lib = new Lib();
        
        hoax(alice);
        hackMe = new HackMe(address(lib));
    }
    
    function testHackOwnership() public {
        address alice = vm.addr(1);
        assertEq(hackMe.owner(), alice);
        
        address eve = vm.addr(3);
        startHoax(eve);

        Attack attack = new Attack(hackMe);
        attack.attack();

        assertEq(hackMe.owner(), address(attack));
    }
}
