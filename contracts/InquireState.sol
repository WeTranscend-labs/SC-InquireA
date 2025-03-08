// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InquireType.sol";
import "./InquireEvent.sol";

abstract contract InquireState {
    uint256 public voteFee = 0.01 ether;
    uint256 public questionIdCounter;
    uint256 public answerIdCounter;

    mapping(uint256 => mapping(uint256 => InquireType.Answer)) public answers;
    mapping(uint256 => mapping(uint256 => uint256[])) public answerReplies; // questionId => answerId => danh sách answer cấp 2
    mapping(address => uint256) public balances;
    mapping(address => InquireType.User) public users;

    address[] public userAddresses;
    mapping(address => bool) public isUserRegistered;
    

    constructor() {
        questionIdCounter = 1;
        answerIdCounter = 1;
    }

    function askQuestion(string memory _questionDetailId, InquireType.DeadlinePeriod _deadlinePeriod) 
        public virtual payable;

    function submitAnswer(uint256 questionId, string memory _answerDetailId, uint256 parentAnswerId) 
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

    function getUser(address user) public view virtual returns (InquireType.User memory);

    function getUsers(uint256 pageIndex, uint256 pageSize) 
        public view virtual returns (
            InquireType.User[] memory usersList,
            uint256 totalUsers,
            uint256 totalPages
        );
}