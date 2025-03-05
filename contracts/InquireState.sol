// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InquireType.sol";
import "./InquireEvent.sol";

abstract contract InquireState {
    uint256 public voteFee = 0.01 ether;
    uint256 public questionIdCounter;
    uint256 public answerIdCounter;

    constructor() {
        questionIdCounter = 1;
        answerIdCounter = 1;
    }

    // Các phương thức trừu tượng yêu cầu triển khai
    function askQuestion(
        string memory _questionText,
        string memory _questionContent,
        string memory _category,
        InquireType.DeadlinePeriod _deadlinePeriod
    ) public virtual payable;

    function submitAnswer(uint256 questionId, string memory _answerText) 
        public virtual;

    function getQuestions(uint256 pageIndex, uint256 pageSize) 
        public view virtual returns (
            InquireType.Question[] memory questionsList,
            uint256 totalQuestions,
            uint256 totalPages
        );

    function selectBestAnswer(uint256 questionId, uint256 answerId) 
        public virtual payable;

    function getQuestionById(uint256 questionId) 
        public view virtual returns (InquireType.Question memory);

    function getAnswersByQuestionId(
        uint256 questionId,
        uint256 pageIndex,
        uint256 pageSize
    ) public view virtual returns (
        InquireType.Answer[] memory answersList,
        uint256 totalAnswers,
        uint256 totalPages
    );

    function getAnswerById(uint256 questionId, uint256 answerId) 
        public view virtual returns (InquireType.Answer memory);

    function voteForAnswer(uint256 questionId, uint256 answerId) 
        public virtual;

    function closeQuestion(uint256 questionId, uint256 answerId) 
        public virtual;

    function distributeRewards(uint256 questionId) 
        public virtual;

    function withdraw() public virtual;

    function balance() public view virtual returns (uint256);

    function getQuestionsByCategory(string memory _category) 
        public view virtual returns (uint256[] memory);
}