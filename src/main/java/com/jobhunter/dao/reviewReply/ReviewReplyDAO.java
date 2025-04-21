package com.jobhunter.dao.reviewReply;

import java.util.List;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;

public interface ReviewReplyDAO {
    List<ReviewReplyDTO> selectRepliesByBoardNo(int boardNo) throws Exception;
    
    
    int insertReply(ReviewReplyDTO dto) throws Exception;
}
