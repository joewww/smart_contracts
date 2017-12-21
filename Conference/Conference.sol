pragma solidity ^0.4.11;

contract Conference {

   // Rinkleby testnet address
   address public organizer = 0x00;
   mapping (address => uint) public registrantsPaid;
   uint public numRegistrants;
   uint private quota = 10;

   function buyTicket() payable public returns (bool success) {
     if (numRegistrants >= quota) {
         revert();
         return false;
     }
     else {
         // 0.1 ETH
         if (msg.value == 100000000000000000)
         {
            registrantsPaid[msg.sender] = msg.value;
            numRegistrants++;
            return true;
         }
         else {
             revert();
             return false;
         }
      }
   }

   function showOrganizer() constant public returns (address) {
       return organizer;
   }

  // Return funds to organizer
  function destroy() public {
     if (msg.sender == organizer) {
        selfdestruct(organizer);
     }
  }
}
