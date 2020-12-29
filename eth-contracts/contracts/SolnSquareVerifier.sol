pragma solidity ^0.6.2;
// SPDX-License-Identifier: UNLICENSED
import './ERC721Mintable.sol';
import "./SquareVerifier.sol";




// TODO define another contract named SolnSquareVerifier that inherits from your ERC721Mintable class
contract SolnSquareVerifier is CustomERC721Token {
  // TODO define a contract call to the zokrates generated solidity contract <Verifier> or <renamedVerifier>
  Verifier verifier;

  constructor(address verifierAddress) public CustomERC721Token("Dwelling Token", "DWLL") {
    verifier = Verifier(verifierAddress);
  }

  // TODO define a solutions struct that can hold an index & an address
  struct Solution {
    bool isFound;
    uint tokenId;
    address winner;
    bool isMinted;
  }


  // TODO define an array of the above struct
  Solution[] private _solutions;


  // TODO define a mapping to store unique solutions submitted
  mapping(bytes32 => Solution) solutions;


  // TODO Create an event to emit when a solution is added
  event AddedSolution();


  // TODO Create a function to add the solutions to the array and emit the event
  function addSolution(
    uint[2] memory a,
    uint[2][2] memory b,
    uint[2] memory c,
    uint[2] memory input
  ) public {
    bool isValid = verifier.verifyTx(a, b, c, input);
    require(isValid, "Solution is incorrect");


    Solution memory solution = Solution({
    isFound : true,
    tokenId : _solutions.length,
    winner : msg.sender,
    isMinted : false
    });
    bytes32 key = getKey(input);

    _solutions.push(solution);
    solutions[key] = solution;

    emit AddedSolution();
  }


  // the input array is the best way to uniquely identify each solution
  function getKey(uint[2] memory input) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked(input[0], input[1]));
  }

  // TODO Create a function to mint new NFT only after the solution has been verified
  function mintNFT(uint[2] memory input, address to) public {
    //  - make sure the solution is unique (has not been used before)
    bytes32 key = getKey(input);
    require(solutions[key].isFound, "That solution is not found");
    require(!solutions[key].isMinted, "That solution has already been rewarded");

    //  - make sure you handle metadata as well as tokenSupply
    mint(to, solutions[key].tokenId);
    solutions[key].isMinted = true;

  }

  function isSolution(uint[2] memory input) public view returns (bool){
    bytes32 key = getKey(input);
    return solutions[key].isFound;
  }

  function getTokenId(uint[2] memory input) public view returns (uint){
    bytes32 key = getKey(input);
    return solutions[key].tokenId;
  }

}

  


























