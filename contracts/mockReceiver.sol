pragma solidity ^0.4.24;

contract Token {
	function transfer(address _to, uint256 _value) public returns (bool success);
	function approveAndCall(address _spender, uint _amount, bytes _data) public returns (bool success);
}

contract ApproveAndCallFallBack {
  function receiveApproval(address from, uint tokens, address token, bytes data) public;
}


contract mockReceiver {

	Token public tokenContract;

	address public userAddress;
	address public tokenAddress;
	address public fromAddress;
	uint public total;


	constructor(address _tokenContract) public {
		tokenContract = Token(_tokenContract);
	}

	function receiveApproval(address from, uint tokens, address token, bytes data) public {
		address x = bytesToAddress(data);
		userAddress = x;
		total = tokens;
		tokenAddress = token;
		fromAddress = from;
	}

  function bytesToAddress(bytes bys)
  internal
  pure
  returns (address addr) {
    assembly {
      addr := mload(add(bys,20))
      }
  }


}
