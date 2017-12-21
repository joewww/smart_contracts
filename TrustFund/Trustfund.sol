pragma solidity ^0.4.11;

contract Trustfund {
    address public owner = msg.sender;
    address public secondary_owner = 0xdead;
    bool public can_withdraw = false;
//  uint constant min_time = 2240006400; // Tuesday, December 25, 2040 12:00:00 AM GMT
    uint constant min_time = 946080000;  // Saturday, December 25, 1999 12:00:00 AM GMT

    function allow_withdraw() public {
        if (msg.sender == owner || msg.sender == secondary_owner) {
            can_withdraw = true;
        }
    }

    function unallow_withdraw() public {
        if (msg.sender == owner || msg.sender == secondary_owner) {
            can_withdraw = false;
        }
    }

    function withdraw() public {
        require (block.timestamp > min_time && can_withdraw);
        if (msg.sender == owner || msg.sender == secondary_owner) {
            selfdestruct(msg.sender);
        }
    }

    function change_owner(address new_owner) public returns (bool) {
        if (msg.sender == owner) {
            owner = new_owner;
            return true;
        }
        return false;
    }

    // Withdraw all funds to owner
    function destroy() public {
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}
