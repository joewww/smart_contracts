pragma solidity ^0.4.23;

// Deadman Switch Trustfund: Allow withdraw of funds if checkin function not executed within timeframe

import './SafeMath.sol';

contract deadmanSwitch {
  using SafeMath for uint;

  address public owner = msg.sender;
  address public beneficiary = 0xdead;
  uint constant year = 31556926;      // Seconds in year
  uint public min_time = 1545739200;  // Tuesday, December 25, 2018 7:00:00 AM GMT-05:00

  // set to true on initial deploy
  bool public alive = true;

  // Confirm alive (should be once a year, but owner can extend indefinitely)
  uint public checkins = 0;

  // Events
  event CheckIn(address who);     // Log CheckIns
  event CheckAlive(address who);  // Log Queries for alive status


  function checkin() public returns (bool) {
    if (msg.sender == owner || msg.sender == beneficiary) {
      alive = true;
      min_time = year.add(min_time);  // Add 1 year to min withdraw time
      checkins = checkins.add(1);
      emit CheckIn(msg.sender); // logging event
      return true;
    }
    return false;
  }

  // Need to set alive status before withdrawing funds
  function checkAlive() public returns (bool) {
    if (block.timestamp > min_time) {
      alive = false; // RIP
      emit CheckAlive(msg.sender);
      return true;
    }
  return true;
  }

  // Set new owner
  function transferOwnership(address newOwner) public {
    require(newOwner != address(0) && owner == msg.sender);
    owner = newOwner;
  }

  // Allow owner to set new beneficiary
  function transferBeneficiary(address newBeneficiary) public {
    require(newBeneficiary != address(0) && owner == msg.sender);
    beneficiary = newBeneficiary;
  }

  // Beneficiary can withdraw funds if owner doesn't check in (checked out)
  function withdraw() public {
    require (block.timestamp > min_time && alive != true);
    if (msg.sender == owner || msg.sender == beneficiary) {
      selfdestruct(msg.sender);
    }
  }

  function () public payable {
  //  balance = msg.value;
  }
}

