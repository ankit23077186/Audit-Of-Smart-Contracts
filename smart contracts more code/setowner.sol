// UNSECURE
function setOwner(bytes32 newOwner, uint8 v, bytes32 r, bytes32 s) external {
	address signer = ecrecover(newOwner, v, r, s);
	require(signer == owner);
	owner = address(newOwner);
}

//The above method is intended to only set a new owner if a valid signature from the existing owner 
//abiis provided. However, as we know, if we set v to any value other than 27 or 28, the signer will
// be the null address and if the current owner is uninitialized or renounced, the require statement 
//will succeed allowing an attacker to set themselves as owner.