// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {

//INTEGERS different types, check it out

//make stuff public so they can show up......read more about at sol docs
    uint256 public favoriteNumber;
    //bool!!
    bool state = true;
    string name = "GAGA";
    address x = 0xdD1E07A1581fA587f37A6938866A074f292A7bc3;
    //even bytes object!!
    bytes32 byteee = "cat"; // you can adjust size of byte

    //WE GOT STRUCTURESSSSSSS!
    struct People {
        uint256 favoriteNumber;
        string name;
    }

//WE GOT STRUCTURE ARRAYS WITH DYNAMIC MEMORY!!!!!! wooooo!!! :v
    People[] public student;

    //maps basically.....or dictionaries
    mapping(string => uint256) public nameToFavoriteNumber;

    //PASS a num to this func, it will replace favnum var with the passed value
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    //well....it retrieves....and returns stuff.....check out view vs pure
    //view--> we are not making changes just checking the blockchain state
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }
    //pure--> does some stuff.....calculations I guess.....read the docs 
    function math(uint256 calculation) public pure returns(uint256){
       return  calculation*2;
    }

    //UNLIMITED PUSHHHH!!!
    // sooo string is an object and you can either store this object at runtine using 'memory' else use 'storage'
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        student.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

// cool deployed a smart contract!....now I lost some GoerliETH :v
 
