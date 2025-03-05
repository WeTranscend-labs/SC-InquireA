// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// File chứa các định nghĩa type cho contract InquireA
library InquireType {
    enum DeadlinePeriod {
        OneWeek,
        TwoWeeks,
        OneMonth
    }

    struct Question {
        uint256 id;
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
        uint256 id;
        address responder;
        string answerText;
        uint256 upvotes;
        uint256 rewardAmount;
        uint256 createdAt;
    }
}