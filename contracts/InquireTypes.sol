// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library InquireType {
    enum DeadlinePeriod {
        OneWeek,
        TwoWeeks,
        OneMonth
    }

    struct Question {
        uint256 id;            
        address asker;       
        string questionDetailId;
        uint256 rewardAmount;    
        uint256 createdAt;       
        uint256 deadline;        
        bool isClosed;           
        uint256 chosenAnswerId;  
    }

    struct Answer {
        uint256 id;              
        address responder;       
        string answerDetailId;  
        uint256 upvotes;         
        uint256 rewardAmount;    
        uint256 createdAt;       
    }

    struct User {
        address userAddress;
        uint256 reputation;       
        uint256 answerCount;      
        uint256 questionCount;    
        uint256 bestSolutionCount; 
    }
}