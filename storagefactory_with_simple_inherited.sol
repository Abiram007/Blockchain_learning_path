// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;
//linking two contracts!
//now when we deploy, we can choose which file to deploy.... imported or existing
import "./simple.sol";

//NOTE: Do inheriitance if we want allll the function which simple.sol holds......make sure to match the contract name
contract storagefactory is simple{

    simple[] public simparr;

    function createsimplecontract() public {
       //similar to creatin class objects....make sure it's type in the name of class....
       //we are creating a simple variable
       //simple simp = new simple();
       //we know simp is created but we cant read now.....solution? put them in a list/array
       simple simp = new simple();
       simparr.push(simp);
       //this simp array will return the address of the contract simple
       //with that adress we can create a new instance with reference to that address ln 26
    }

    function sfstore(uint256 storageindex,uint256 storagenumber) public {
        //to interact with contracts we need address and ABI(yep...that's my name...yay!)
        //ABI - application binary interface
        simple copy = simple(address(simparr[storageindex]));
        //calling the store function present in simple contract
        copy.store(storagenumber);
    }

    function sfget(uint256 storageindex) public view returns(uint256){
        simple get_copy = simple(address(simparr[storageindex]));
        return get_copy.retrieve();

        // or we could do
        // return simple(address(simparr[storageindex])).retrieve();
    }
}
