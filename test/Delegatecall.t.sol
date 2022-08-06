// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Delegatecall.sol";

contract DelegatecallTest is Test {
    Lib public lib;
    HackMe public hackMe;
    
    function setUp() public {
        address alice = vm.addr(1);
        
        hoax(alice);
        lib = new Lib();
        
        hoax(alice);
        hackMe = new HackMe(lib);
    }
    
    function testHackOwnership() public {
        address alice = vm.addr(1);
        assertEq(hackMe.owner(), alice);
        
        address eve = vm.addr(3);
        startHoax(eve);

        Attack attack = new Attack(address(hackMe));
        attack.attack();

        assertEq(hackMe.owner(), address(attack));
    }
}
