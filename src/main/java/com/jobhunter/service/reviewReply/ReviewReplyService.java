package com.jobhunter.service.reviewReply;

import java.util.List;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;

public interface ReviewReplyService {
	List<ReviewReplyDTO> getRepliesByBoardNo(int boardNo) throws Exception;

	boolean insertReply(ReviewReplyDTO dto) throws Exception;
}
