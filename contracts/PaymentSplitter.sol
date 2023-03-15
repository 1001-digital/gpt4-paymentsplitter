// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @title PaymentSplitter
/// @dev A simple payment splitter contract that allows funds to be split among receivers.
contract PaymentSplitter is Ownable {
    /// @dev The Receiver struct contains the address and basis points for each receiver.
    struct Receiver {
        address addr;
        uint256 basisPoints;
    }

    /// @dev An array of Receiver structs.
    Receiver[] public receivers;

    /// @notice Sets the receivers and their corresponding basis points.
    /// @dev The total basis points must equal 10000, and the input arrays must have the same length.
    /// @param addresses An array of receiver addresses.
    /// @param basisPoints An array of basis points for each receiver.
    function setReceivers(address[] calldata addresses, uint256[] calldata basisPoints) external onlyOwner {
        require(addresses.length == basisPoints.length, "Input arrays must have the same length");
        require(addresses.length > 0, "At least one receiver must be set");

        uint256 totalBasisPoints;
        for (uint256 i = 0; i < basisPoints.length; i++) {
            totalBasisPoints += basisPoints[i];
        }
        require(totalBasisPoints == 10000, "Total basis points must equal 10000");

        delete receivers;
        for (uint256 i = 0; i < addresses.length; i++) {
            receivers.push(Receiver({ addr: addresses[i], basisPoints: basisPoints[i] }));
        }
    }

    /// @notice Withdraws the contract's entire balance and splits it among the receivers according to their basis points.
    /// @dev This function can only be called by the contract owner.
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        for (uint256 i = 0; i < receivers.length; i++) {
            Receiver storage r = receivers[i];
            uint256 amount = (balance * r.basisPoints) / 10000;
            payable(r.addr).transfer(amount);
        }
    }

    /// @notice Fallback function to receive funds.
    receive() external payable {}
}
