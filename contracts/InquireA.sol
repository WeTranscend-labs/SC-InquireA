// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InquireA {
    address public owner;
    uint256 public voteFee = 0.01 ether; 
    uint256 public questionIdCounter;
     uint256 public constant WEEK = 7 days;
    uint256 public constant TWO_WEEKS = 14 days;
    uint256 public constant MONTH = 30 days;

    enum DeadlinePeriod {
        OneWeek,
        TwoWeeks,
        OneMonth
    }

struct Question {
    address asker;
    string questionText;
    string questionContent; 
    string category;
    uint256 rewardAmount;
    uint256 createdAt;
    uint256 deadline;  
    bool isClosed;
    uint256 chosenAnswerId;
}

    struct Answer {
        address responder;
        string answerText;
        uint256 upvotes;
        uint256 rewardAmount;
        uint256 createdAt;
    }

    mapping(uint256 => Question) public questions;
    mapping(uint256 => mapping(uint256 => Answer)) public answers;
    mapping(address => uint256) public balances;

    event QuestionAsked(
        uint256 questionId, 
        address indexed asker, 
        string questionText, 
        uint256 rewardAmount,
        string category
    );
    event AnswerSubmitted(uint256 questionId, uint256 answerId, address indexed responder, string answerText);
    event Voted(uint256 questionId, uint256 answerId, address indexed voter);
    event QuestionClosed(uint256 questionId, uint256 chosenAnswerId);

    constructor() {
        owner = msg.sender;
    }

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

    // Đặt câu hỏi với category là string
function askQuestion(
    string memory _questionText,
    string memory _questionContent, // Thêm tham số mới
    string memory _category,
    DeadlinePeriod _deadlinePeriod
) public payable {
    require(msg.value > 0, "Reward must be greater than zero");
    require(bytes(_category).length > 0, "Category cannot be empty");
    
    uint256 deadline;
    if (_deadlinePeriod == DeadlinePeriod.OneWeek) {
        deadline = block.timestamp + WEEK;
    } else if (_deadlinePeriod == DeadlinePeriod.TwoWeeks) {
        deadline = block.timestamp + TWO_WEEKS;
    } else if (_deadlinePeriod == DeadlinePeriod.OneMonth) {
        deadline = block.timestamp + MONTH;
    }
    
    uint256 questionId = questionIdCounter++;
    questions[questionId] = Question({
        asker: msg.sender,
        questionText: _questionText,
        questionContent: _questionContent, // Thêm trường mới
        category: _category,
        rewardAmount: msg.value,
        createdAt: block.timestamp,
        deadline: deadline,
        isClosed: false,
        chosenAnswerId: 0
    });

    emit QuestionAsked(questionId, msg.sender, _questionText, msg.value, _category);
}

    function getQuestions(uint256 pageIndex, uint256 pageSize) 
        public 
        view 
        returns (Question[] memory) 
    {
        require(pageIndex > 0, "Page index must start from 1");
        require(pageSize > 0, "Page size must be greater than 0");

        uint256 startIndex = (pageIndex - 1) * pageSize;
        require(startIndex < questionIdCounter, "Invalid page index");

        uint256 endIndex = startIndex + pageSize;
        if (endIndex > questionIdCounter) {
            endIndex = questionIdCounter; // Đảm bảo không vượt quá số lượng câu hỏi
        }

        uint256 resultSize = endIndex - startIndex;
        Question[] memory paginatedQuestions = new Question[](resultSize);

        for (uint256 i = startIndex; i < endIndex; i++) {
            paginatedQuestions[i - startIndex] = questions[i];
        }

        return paginatedQuestions;
    }




    // Trả lời câu hỏi
    function submitAnswer(uint256 questionId, string memory _answerText) public questionExists(questionId) notClosed(questionId) {
        Question memory question = questions[questionId];
        require(block.timestamp <= question.deadline, "Question deadline has passed");

        uint256 answerId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        answers[questionId][answerId] = Answer({
            responder: msg.sender,
            answerText: _answerText,
            upvotes: 0,
            rewardAmount: 0,
            createdAt: block.timestamp
        });
    }

    // Bỏ phiếu
    function voteForAnswer(uint256 questionId, uint256 answerId) public payable questionExists(questionId) notClosed(questionId) {
        Question memory question = questions[questionId];
        require(block.timestamp <= question.deadline, "Voting period has ended");
        
        require(msg.value == voteFee, "Incorrect vote fee");

        Answer storage answer = answers[questionId][answerId];
        answer.upvotes += 1;
        questions[questionId].rewardAmount += msg.value;
    }

    // Đóng câu hỏi
    function closeQuestion(uint256 questionId, uint256 answerId) public questionExists(questionId) notClosed(questionId) {
        Question storage question = questions[questionId];
        require(msg.sender == question.asker, "Only asker can close question");

        question.isClosed = true;
        question.chosenAnswerId = answerId;

        emit QuestionClosed(questionId, answerId);
    }

    // Phân phối phần thưởng
    function distributeRewards(uint256 questionId) public questionExists(questionId) {
        Question storage question = questions[questionId];
        require(block.timestamp > question.deadline, "Cannot distribute before deadline");
        require(!question.isClosed, "Question is already closed");

        uint256 totalUpvotes = 0;
        uint256 totalReward = question.rewardAmount;

        // Tính tổng upvote
        for (uint256 i = 0; i < questionIdCounter; i++) {
            totalUpvotes += answers[questionId][i].upvotes;
        }

        // Chia phần thưởng
        for (uint256 i = 0; i < questionIdCounter; i++) {
            Answer storage answer = answers[questionId][i];
            if (totalUpvotes > 0) {
                uint256 reward = (answer.upvotes * totalReward) / totalUpvotes;
                answer.rewardAmount += reward;
                balances[answer.responder] += reward;
            }
        }

        question.isClosed = true;
    }

    // Các hàm khác giữ nguyên
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");
        
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    // Truy vấn câu hỏi theo category
    function getQuestionsByCategory(string memory _category) public view returns (uint256[] memory) {
        uint256[] memory matchedQuestions = new uint256[](questionIdCounter);
        uint256 count = 0;

        for (uint256 i = 0; i < questionIdCounter; i++) {
            if (keccak256(bytes(questions[i].category)) == keccak256(bytes(_category))) {
                matchedQuestions[count] = i;
                count++;
            }
        }

        // Resize mảng
        uint256[] memory result = new uint256[](count);
        for (uint256 i = 0; i < count; i++) {
            result[i] = matchedQuestions[i];
        }

        return result;
    }
}