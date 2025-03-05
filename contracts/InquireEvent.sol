// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Interface chứa các định nghĩa event cho contract InquireA
interface InquireEvent {
    event QuestionAsked(
        uint256 questionId, 
        address indexed asker, 
        string questionText, 
        uint256 rewardAmount,
        string category
    );
    event AnswerSubmitted(
        uint256 questionId, 
        uint256 answerId, 
        address indexed responder, 
        string answerText
    );
    event Voted(
        uint256 questionId, 
        uint256 answerId, 
        address indexed voter
    );
    event QuestionClosed(
        uint256 questionId, 
        uint256 chosenAnswerId
    );
}