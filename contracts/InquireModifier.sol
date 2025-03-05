// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InquireType.sol";

abstract contract InquireModifier {
    address public owner;
    mapping(uint256 => InquireType.Question) public questions;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this");
        _;
    }

    modifier questionExists(uint256 questionId) {
        require(questions[questionId].asker != address(0), "Question does not exist");
        _;
    }

    modifier notClosed(uint256 questionId) {
        require(!questions[questionId].isClosed, "Question is already closed");
        _;
    }
}