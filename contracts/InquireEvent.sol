// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract InquireEvent {
    event QuestionAsked(
        uint256 indexed questionId,
        address indexed asker,
        string questionDetailId,
        uint256 rewardAmount
    );

    event AnswerSubmitted(
        uint256 indexed questionId,
        uint256 indexed answerId,
        address indexed responder,
        string answerDetailId 
    );

    event Voted(
        uint256 indexed questionId,
        uint256 indexed answerId,
        address indexed voter
    );

    event QuestionClosed(uint256 indexed questionId, uint256 chosenAnswerId);
}