// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InquireType.sol";
import "./InquireEvent.sol";
import "./InquireModifier.sol";
import "./InquireConstants.sol";
import "./InquireState.sol";

contract InquireA is InquireEvent, InquireModifier, InquireState {
    mapping(uint256 => mapping(uint256 => InquireType.Answer)) public answers;
    mapping(address => uint256) public balances;

    constructor() {
        owner = msg.sender;
    }

    function askQuestion(
        string memory _questionText,
        string memory _questionContent, 
        string memory _category,
        InquireType.DeadlinePeriod _deadlinePeriod
    ) public override payable {
        require(msg.value > 0, "Reward must be greater than zero");
        require(bytes(_category).length > 0, "Category cannot be empty");

        uint256 deadline;
        if (_deadlinePeriod == InquireType.DeadlinePeriod.OneWeek) {
            deadline = block.timestamp + InquireConstants.WEEK;
        } else if (_deadlinePeriod == InquireType.DeadlinePeriod.TwoWeeks) {
            deadline = block.timestamp + InquireConstants.TWO_WEEKS;
        } else if (_deadlinePeriod == InquireType.DeadlinePeriod.OneMonth) {
            deadline = block.timestamp + InquireConstants.MONTH;
        }
        
        uint256 questionId = questionIdCounter++;
        questions[questionId] = InquireType.Question({
            id: questionId,
            asker: msg.sender,
            questionText: _questionText,
            questionContent: _questionContent, 
            category: _category,
            rewardAmount: msg.value,
            createdAt: block.timestamp,
            deadline: deadline,
            isClosed: false,
            chosenAnswerId: 0
        });

        emit QuestionAsked(questionId, msg.sender, _questionText, msg.value, _category);
    }

    function submitAnswer(uint256 questionId, string memory _answerText) 
        public 
        override 
        questionExists(questionId)
        notClosed(questionId) 
    {
        InquireType.Question memory question = questions[questionId];
        require(block.timestamp <= question.deadline, "Question deadline has passed");

        uint256 answerId = answerIdCounter++;
        answers[questionId][answerId] = InquireType.Answer({
            id: answerId,
            responder: msg.sender,
            answerText: _answerText,
            upvotes: 0,
            rewardAmount: 0,
            createdAt: block.timestamp
        });

        emit AnswerSubmitted(questionId, answerId, msg.sender, _answerText);
    }

    function getQuestions(uint256 pageIndex, uint256 pageSize) 
        public 
        view 
        override 
        returns (
            InquireType.Question[] memory questionsList, 
            uint256 totalQuestions, 
            uint256 totalPages
        ) 
    {
        require(pageIndex > 0, "Page index must start from 1");
        require(pageSize > 0, "Page size must be greater than 0");

        totalQuestions = questionIdCounter - 1;

        if (totalQuestions == 0) {
            return (new InquireType.Question[](0), 0, 0);
        }

        totalPages = (totalQuestions + pageSize - 1) / pageSize;

        require(pageIndex <= totalPages, "Invalid page index");

        uint256 startIndex = (pageIndex - 1) * pageSize + 1;
        uint256 endIndex = startIndex + pageSize - 1;

        if (endIndex > questionIdCounter - 1) {
            endIndex = questionIdCounter - 1;
        }

        uint256 resultSize = endIndex - startIndex + 1;
        questionsList = new InquireType.Question[](resultSize);

        uint256 index = 0;
        for (uint256 i = startIndex; i <= endIndex; i++) {
            questionsList[index] = questions[i];
            index++;
        }

        return (questionsList, totalQuestions, totalPages);
    }

    function selectBestAnswer(uint256 questionId, uint256 answerId) 
        public 
        override 
        payable 
        questionExists(questionId)
        notClosed(questionId) 
    {
        require(msg.sender == questions[questionId].asker, "Only question asker can select the best answer");
        require(answers[questionId][answerId].responder != address(0), "Answer does not exist");

        questions[questionId].isClosed = true;
        questions[questionId].chosenAnswerId = answerId;

        address bestResponder = answers[questionId][answerId].responder;
        uint256 totalReward = questions[questionId].rewardAmount;

        answers[questionId][answerId].rewardAmount = totalReward;

        payable(bestResponder).transfer(totalReward);

        emit QuestionClosed(questionId, answerId);
    }

    function getQuestionById(uint256 questionId) 
        public 
        view 
        override 
        returns (InquireType.Question memory) 
    {
        require(questions[questionId].asker != address(0), "Question does not exist");
        return questions[questionId];
    }

    function getAnswersByQuestionId(
        uint256 questionId, 
        uint256 pageIndex, 
        uint256 pageSize
    ) public view override returns (
        InquireType.Answer[] memory answersList, 
        uint256 totalAnswers, 
        uint256 totalPages
    ) {
        require(questions[questionId].asker != address(0), "Question does not exist");
        require(pageIndex > 0, "Page index must start from 1");
        require(pageSize > 0, "Page size must be greater than 0");

        uint256 answersCount = 0;
        for (uint256 i = 1; i < answerIdCounter; i++) {
            if (answers[questionId][i].responder != address(0)) {
                answersCount++;
            }
        }

        totalAnswers = answersCount;

        if (totalAnswers == 0) {
            return (new InquireType.Answer[](0), 0, 0);
        }

        totalPages = (totalAnswers + pageSize - 1) / pageSize;
        require(pageIndex <= totalPages, "Invalid page index");

        uint256 startIndex = (pageIndex - 1) * pageSize + 1;
        uint256 endIndex = startIndex + pageSize - 1;

        if (endIndex > answerIdCounter - 1) {
            endIndex = answerIdCounter - 1;
        }

        uint256 resultSize = 0;
        for (uint256 i = startIndex; i <= endIndex; i++) {
            if (answers[questionId][i].responder != address(0)) {
                resultSize++;
            }
        }

        answersList = new InquireType.Answer[](resultSize);
        uint256 index = 0;

        for (uint256 i = startIndex; i <= endIndex; i++) {
            if (answers[questionId][i].responder != address(0)) {
                answersList[index] = answers[questionId][i];
                index++;
            }
        }

        return (answersList, totalAnswers, totalPages);
    }

    function getAnswerById(uint256 questionId, uint256 answerId) 
        public 
        view 
        override 
        returns (InquireType.Answer memory) 
    {
        require(answers[questionId][answerId].responder != address(0), "Answer does not exist");
        return answers[questionId][answerId];
    }

    function voteForAnswer(uint256 questionId, uint256 answerId) 
        public 
        override 
        questionExists(questionId)
        notClosed(questionId) 
    {
        InquireType.Question memory question = questions[questionId];
        require(block.timestamp <= question.deadline, "Voting period has ended");

        InquireType.Answer storage answer = answers[questionId][answerId];
        answer.upvotes += 1;

        emit Voted(questionId, answerId, msg.sender);
    }

    function closeQuestion(uint256 questionId, uint256 answerId) 
        public 
        override 
        questionExists(questionId)
        notClosed(questionId) 
    {
        InquireType.Question storage question = questions[questionId];
        require(msg.sender == question.asker, "Only asker can close question");

        question.isClosed = true;
        question.chosenAnswerId = answerId;

        emit QuestionClosed(questionId, answerId);
    }

    function distributeRewards(uint256 questionId) 
        public 
        override 
        questionExists(questionId) 
    {
        InquireType.Question storage question = questions[questionId];
        require(block.timestamp > question.deadline, "Cannot distribute before deadline");
        require(!question.isClosed, "Question is already closed");

        uint256 totalUpvotes = 0;
        uint256 totalReward = question.rewardAmount;

        for (uint256 i = 0; i < answerIdCounter; i++) {
            totalUpvotes += answers[questionId][i].upvotes;
        }

        for (uint256 i = 0; i < answerIdCounter; i++) {
            InquireType.Answer storage answer = answers[questionId][i];
            if (totalUpvotes > 0) {
                uint256 reward = (answer.upvotes * totalReward) / totalUpvotes;
                answer.rewardAmount += reward;
                balances[answer.responder] += reward;
            }
        }

        question.isClosed = true;
    }

    function withdraw() 
        public 
        override 
        onlyOwner 
    {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");

        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function balance() public view override returns (uint256) {
        return address(this).balance;
    }

    function getQuestionsByCategory(string memory _category) 
        public 
        view 
        override 
        returns (uint256[] memory) 
    {
        uint256[] memory matchedQuestions = new uint256[](questionIdCounter);
        uint256 count = 0;

        for (uint256 i = 1; i < questionIdCounter; i++) {
            if (keccak256(bytes(questions[i].category)) == keccak256(bytes(_category))) {
                matchedQuestions[count] = i;
                count++;
            }
        }

        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = matchedQuestions[i];
        }

        return result;
    }
}