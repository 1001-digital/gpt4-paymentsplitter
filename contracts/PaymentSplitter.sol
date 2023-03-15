// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PaymentSplitter is Ownable {
    struct Receiver {
        address addr;
        uint256 basisPoints;
    }

    Receiver[] public receivers;

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

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        for (uint256 i = 0; i < receivers.length; i++) {
            Receiver storage r = receivers[i];
            uint256 amount = (balance * r.basisPoints) / 10000;
            payable(r.addr).transfer(amount);
        }
    }

    receive() external payable {}
}
