pragma solidity ^0.6.2;
// SPDX-License-Identifier: UNLICENSED

import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./provableAPI_0.6.sol";

contract Ownable {
  //  TODO's
  //  1) create a private '_owner' variable of type address with a public getter function
  address private _owner;

  function getOwner() public view returns (address) {
    return _owner;
  }
  //  2) create an internal constructor that sets the _owner var to the creator of the contract
  constructor() public {
    _owner = msg.sender;
    transferOwnership(msg.sender);
  }
  //  3) create an 'onlyOwner' modifier that throws if called by any account other than the owner.
  modifier onlyOwner () {
    require(_owner == msg.sender, "Only the owner is allowed to perform this action");
    _;
  }
  //  4) fill out the transferOwnership function
  function transferOwnership(address newOwner) public onlyOwner {
    // TODO add functionality to transfer control of the contract to a newOwner.
    // make sure the new owner is a real address
    require(newOwner != address(0));
    address origOwner = _owner;
    _owner = newOwner;
    emit TransferOwnership(origOwner, newOwner);

  }
  //  5) create an event that emits anytime ownerShip is transferred (including in the constructor)
  event TransferOwnership(address indexed oldOwner, address indexed newOwner);

}

//  TODO: Create a Pausable contract that inherits from the Ownable contract
contract Pausable is Ownable {
  //  1) create a private '_paused' variable of type bool
  bool private _paused;

  //  2) create a public setter using the inherited onlyOwner modifier
  function pause() public onlyOwner {
    _paused = true;
    emit Paused(msg.sender);
  }

  function play() public onlyOwner {
    _paused = false;
    emit Unpaused(msg.sender);
  }

  //  3) create an internal constructor that sets the _paused variable to false
  constructor() internal {
    _paused = false;
  }

  //  4) create 'whenNotPaused' & 'paused' modifier that throws in the appropriate situation
  modifier whenNotPaused() {
    require(_paused == false, "Contract is paused");
    _;
  }
  modifier paused() {
    require(_paused == true, "Contract is not paused");
    _;
  }
  //  5) create a Paused & Unpaused event that emits the address that triggered the event
  event Paused(address indexed pausedBy);
  event Unpaused(address indexed unpausedBy);

}


//  TODO's: Create CustomERC721Token contract that inherits from the ERC721Metadata contract. You can name this contract as you please
//  1) Pass in appropriate values for the inherited ERC721Metadata contract
//      - make the base token uri: https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/
//  2) create a public mint() that does the following:
//      -can only be executed by the contract owner
//      -takes in a 'to' address, tokenId, and tokenURI as parameters
//      -returns a true boolean upon completion of the function
//      -calls the superclass mint and setTokenURI functions

contract CustomERC721Token is ERC721, Pausable, usingProvable {

  constructor(string memory name, string memory symbol)
  ERC721(name, symbol)
  public {
    _setBaseURI("https://s3-us-west-2.amazonaws.com/udacity-blockchain/capstone/");
  }

  function mint(address to, uint tokenId) public onlyOwner returns (bool) {
    _mint(to, tokenId);
    return true;
  }

}



