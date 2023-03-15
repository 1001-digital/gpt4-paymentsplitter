// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PaymentSplitter is Ownable {
    using SafeMath for uint256;

    struct Receiver {
        address payable addr;
        uint256 basisPoints;
    }

    Receiver[] public receivers;

    event PaymentReceived(address from, uint256 amount);
    event PaymentWithdrawn(uint256 totalAmount);

    /// @notice Receive any funds sent to the contract.
    /// @dev This function emits a PaymentReceived event.
    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
    }

    /// @notice Set the payment receivers and their basis points.
    /// @param _receivers Array of receiver structs containing receiver addresses and their basis points.
    /// @dev This function can only be called by the contract owner and requires the total basis points to equal 10000.
    function setReceivers(Receiver[] calldata _receivers) external onlyOwner {
        uint256 totalBasisPoints = 0;

        for (uint256 i = 0; i < _receivers.length; i++) {
            totalBasisPoints = totalBasisPoints.add(_receivers[i].basisPoints);
        }

        require(totalBasisPoints == 10000, "Total basis points must equal 10000");

        receivers = _receivers;
    }

    /// @notice Withdraw the entire contract balance and split it among the receivers according to their basis points.
    /// @dev This function can only be called by the contract owner and emits a PaymentWithdrawn event.
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        for (uint256 i = 0; i < receivers.length; i++) {
            uint256 amount = balance.mul(receivers[i].basisPoints).div(10000);
            receivers[i].addr.transfer(amount);
        }

        emit PaymentWithdrawn(balance);
    }
}
