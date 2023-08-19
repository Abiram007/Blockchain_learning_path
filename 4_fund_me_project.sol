// SPDX-License-Identifier: MIT
//THIS IS GONNA HAVE LOOOTS OF COMMENTS
// It is a basic Smart contract that lets anyone deposit ETH into the contract
// where only the owner of the contract can withdraw the ETH, making the others who deposited a walking L
pragma solidity >=0.6.0 <0.9.0; 
// Get the latest ETH/USD price from chainlink price feed

//This contract has been updated to use the Goerli testnet, initially it was on sepolia I guess
//https://docs.chain.link/docs/get-the-latest-price/
//that link hass all deets about pricefeeds and address for different conversion on different testnets

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";
//safe math is not necessary for compilers above v8.....so I ignored it xD

contract FundMe {
    // safe math library check uint256 for integer overflows
    //using SafeMathChainlink for uint256;

    //mapping to store which address depositeded how much ETH
    mapping(address => uint256) public addressToAmountFunded;
    // array of addresses who deposited
    address[] public funders;
    //address of the owner (who deployed the contract)
    address public owner;

    // the first person to deploy the contract is
    // the owner
    constructor() public {
        owner = msg.sender;
    } //Ignore the warnings because we are gonna depoly it

    function fund() public payable {
        // 18 digit number to be compared with donated amount
        uint256 minimumUSD = 1 * 10**18;
        //is the donated amount less than 1USD? I changed it cuz I have only 0.08ETH :v
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );
        //if not, add to mapping and funders array
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    //function to get the version of the chainlink pricefeed
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData(); 
        //it is a tuple because priceFeed.latestRoundData() could return 5 values....I'm not gonna store 4 of them.....I just need one sooo
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount)public view returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    //cool stuff tbh....learn more later
    modifier onlyOwner() {
        //is the message sender owner of the contract?
        require(msg.sender == owner);

        _;
    }

    // onlyOwner modifer will first check the condition inside it
    // and
    // if true, withdraw function will be executed
    function withdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);

        //iterate through all the mappings and make them 0
        //since all the deposited amount has been withdrawn
        //its a basic for loop....similar syntax....nothing special
        for (uint256 funderIndex = 0;funderIndex < funders.length;funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        //funders array will be initialized to 0
        funders = new address[](0);
        //broke lmao
    }
}
