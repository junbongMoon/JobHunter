package com.jobhunter.service.reviewReply;

import java.util.List;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;

public interface ReviewReplyService {
	List<ReviewReplyDTO> getRepliesByBoardNo(int boardNo) throws Exception;

	boolean insertReply(ReviewReplyDTO dto) throws Exception;
	
	boolean updateReply(ReviewReplyDTO dto) throws Exception;
	
	boolean deleteReply(int replyNo, int userId) throws Exception;
}
