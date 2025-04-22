package com.jobhunter.dao.reviewReply;

import java.util.List;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;

public interface ReviewReplyDAO {
    List<ReviewReplyDTO> selectRepliesByBoardNo(int boardNo) throws Exception;
    
    
    int insertReply(ReviewReplyDTO dto) throws Exception;
    
    int updateReplyDao(ReviewReplyDTO dto) throws Exception;
    
    int deleteReplyDao(int replyNo, int userId) throws Exception;


	List<ReviewReplyDTO> selectRepliesWithPaging(int boardNo, int offset, int size) throws Exception;


	int countRepliesByBoardNo(int boardNo) throws Exception;
}
