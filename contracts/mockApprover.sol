pragma solidity ^0.4.24;

contract Token {
	function transfer(address _to, uint256 _value) public returns (bool success);
	function approveAndCall(address _spender, uint _amount, bytes _data) public returns (bool success);
}

contract mockApprover {

	Token public tokenContract;
  address public mockReceiver;

	constructor(address _tokenContract, address _mockReceiver) public {
		tokenContract = Token(_tokenContract);
    mockReceiver = _mockReceiver;
	}

  function sendTo(uint _amount, address _who) public {
    tokenContract.approveAndCall(mockReceiver, _amount, toBytes(_who));
  }

  function toBytes(address a)
		internal
		pure
		returns
		(bytes b){
		   assembly {
		        let m := mload(0x40)
		        mstore(add(m, 20), xor(0x140000000000000000000000000000000000000000, a))
		        mstore(0x40, add(m, 52))
		        b := m
		   }
		}
}
