pragma solidity ^0.4.11;

// KeyServer contract: Store public key hashes

contract KeyServer {
   address public owner = msg.sender;
   // Map public key hash to address
   mapping (address => bytes) private pubkeyHashes;
   uint public numHashes;

   // Store new hash
   function storeHash(bytes newHash) public returns (bool success) {
        if(pubkeyHashes[msg.sender].length < 1)
        {
          pubkeyHashes[msg.sender] = newHash;
          numHashes++;
          return true;
        }
        // address already has associated hash
        return false;
   }

   // Update existing hash
   function updateHash(bytes newHash) public returns (bool success) {
        if(pubkeyHashes[msg.sender].length > 1)
        {
          pubkeyHashes[msg.sender] = newHash;
        }
        return true;
   }

   // This shows the latest stored hash for given address. Bug? Feature?
   function viewHash(address checkAddress) constant public returns (bytes) {
       return pubkeyHashes[checkAddress];
   }

  // Return funds to owner
  function destroy() public {
     if (msg.sender == owner) {
        selfdestruct(owner);
     }
  }
}
