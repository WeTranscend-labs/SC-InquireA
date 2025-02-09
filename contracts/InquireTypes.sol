// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library InquireTypes {
    uint256 public constant WEEK = 7 days;
    uint256 public constant TWO_WEEKS = 14 days;
    uint256 public constant MONTH = 30 days;

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

    function calculateDeadline(DeadlinePeriod _deadlinePeriod) internal view returns (uint256) {
        if (_deadlinePeriod == DeadlinePeriod.OneWeek) {
            return block.timestamp + WEEK;
        } else if (_deadlinePeriod == DeadlinePeriod.TwoWeeks) {
            return block.timestamp + TWO_WEEKS;
        } else {
            return block.timestamp + MONTH;
        }
    }
}
