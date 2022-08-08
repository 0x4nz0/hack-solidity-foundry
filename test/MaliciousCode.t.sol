// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MaliciousCode.sol";

contract MaliciousCodeTest is Test {
    event Log(string message);
    
    Bar public bar;
    Mal public mal;
    
    function setUp() public {
        address eve = vm.addr(3);
        vm.prank(eve);
        mal = new Mal();
        vm.prank(eve);
        bar = new Bar();
    }
    
    function testMalLogExecuted() public {
        address eve = vm.addr(3);
        vm.prank(eve);
        Foo foo = new Foo(address(mal));
        
        vm.expectEmit(false, false, false, true, address(mal));
        emit Log("Mal was called");

        address alice = vm.addr(1);
        vm.prank(alice);
        foo.callBar();
    }
    
    function testBarLogExecuted() public {
        address eve = vm.addr(3);
        vm.prank(eve);
        Foo foo = new Foo(address(bar));
        
        vm.expectEmit(false, false, false, true, address(bar));
        emit Log("Bar was called");

        address alice = vm.addr(1);
        vm.prank(alice);
        foo.callBar();
    }
}
