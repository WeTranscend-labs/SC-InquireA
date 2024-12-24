// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InquireA {
    address public owner;
    uint256 public voteFee = 0.01 ether; // Phí cố định cho mỗi vote
    uint256 public votingPeriod = 7 days; // Thời gian bỏ phiếu
    uint256 public questionIdCounter;

    struct Question {
        address asker;
        string questionText;
        uint256 rewardAmount;
        uint256 createdAt;
        bool isClosed;
        uint256 chosenAnswerId;
    }

    struct Answer {
        address responder;
        string answerText;
        uint256 upvotes;
        uint256 rewardAmount;
    }

    mapping(uint256 => Question) public questions;
    mapping(uint256 => mapping(uint256 => Answer)) public answers; // mapping từ questionId và answerId đến answer
    mapping(address => uint256) public balances; // lưu trữ số dư của người dùng

    event QuestionAsked(uint256 questionId, address indexed asker, string questionText, uint256 rewardAmount);
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

    // Đặt câu hỏi và gửi tiền thưởng
    function askQuestion(string memory _questionText) public payable {
        require(msg.value > 0, "Reward must be greater than zero");
        
        uint256 questionId = questionIdCounter++;
        questions[questionId] = Question({
            asker: msg.sender,
            questionText: _questionText,
            rewardAmount: msg.value,
            createdAt: block.timestamp,
            isClosed: false,
            chosenAnswerId: 0
        });

        emit QuestionAsked(questionId, msg.sender, _questionText, msg.value);
    }

    // Trả lời câu hỏi
    function submitAnswer(uint256 questionId, string memory _answerText) public questionExists(questionId) notClosed(questionId) {
        uint256 answerId = uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp)));
        answers[questionId][answerId] = Answer({
            responder: msg.sender,
            answerText: _answerText,
            upvotes: 0,
            rewardAmount: 0
        });

        emit AnswerSubmitted(questionId, answerId, msg.sender, _answerText);
    }

    // Bỏ phiếu cho câu trả lời
    function voteForAnswer(uint256 questionId, uint256 answerId) public payable questionExists(questionId) notClosed(questionId) {
        require(msg.value == voteFee, "Incorrect vote fee");

        Answer storage answer = answers[questionId][answerId];
        answer.upvotes += 1; // Tăng số lượng upvote

        // Cộng phí vote vào quỹ
        questions[questionId].rewardAmount += msg.value;

        emit Voted(questionId, answerId, msg.sender);
    }

    // Đóng câu hỏi và chọn câu trả lời hay nhất
    function closeQuestion(uint256 questionId, uint256 answerId) public questionExists(questionId) notClosed(questionId) {
        require(msg.sender == questions[questionId].asker, "Only asker can close question");

        questions[questionId].isClosed = true;
        questions[questionId].chosenAnswerId = answerId;

        emit QuestionClosed(questionId, answerId);
    }

    // Tự động chia quỹ nếu hết thời gian bỏ phiếu và người đăng câu hỏi chưa chọn câu trả lời
    function distributeRewards(uint256 questionId) public questionExists(questionId) {
        require(block.timestamp >= questions[questionId].createdAt + votingPeriod, "Voting period has not ended yet");
        require(!questions[questionId].isClosed, "Question is already closed");

        uint256 totalUpvotes = 0;
        uint256 totalReward = questions[questionId].rewardAmount;

        // Tính tổng số upvote
        for (uint256 i = 0; i < questionIdCounter; i++) {
            totalUpvotes += answers[questionId][i].upvotes;
        }

        // Chia quỹ cho các câu trả lời
        for (uint256 i = 0; i < questionIdCounter; i++) {
            Answer storage answer = answers[questionId][i];
            uint256 reward = (answer.upvotes * totalReward) / totalUpvotes;
            answer.rewardAmount += reward;
            balances[answer.responder] += reward; // Cộng phần thưởng vào tài khoản người trả lời
        }
    }

    // Rút tiền
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No funds to withdraw");
        
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Kiểm tra số dư trong hợp đồng
    function balance() public view returns (uint256) {
        return address(this).balance;
    }
}
