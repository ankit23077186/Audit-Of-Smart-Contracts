// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.9.0;

contract Map {
    mapping(uint => uint)[] array;

    function allocate(uint newMaps) public {
        for (uint i = 0; i < newMaps; i++)
            array.push();
    }

    function writeMap(uint map, uint key, uint value) public {
        array[map][key] = value;
    }

    function readMap(uint map, uint key) public view returns (uint) {
        return array[map][key];
    }

    function eraseMaps() public {
        delete array;
    }
}
//Consider the example above and the following sequence of calls: allocate(10), 
//writeMap(4, 128, 256). At this point, calling readMap(4, 128) returns 256. If we call eraseMaps,
// the length of the state variable array is zeroed, but since its mapping elements cannot be zeroed, 
//their information stays alive in the contract’s storage. After deleting array, calling allocate(5) 
//allows us to access array[4] again, and calling readMap(4, 128) returns 256 even without another call to writeMap