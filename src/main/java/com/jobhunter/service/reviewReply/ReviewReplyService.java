package com.jobhunter.service.reviewReply;

import java.util.List;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;
import com.jobhunter.model.reviewboard.RPageRequestDTO;

public interface ReviewReplyService {
	List<ReviewReplyDTO> getRepliesByBoardNo(int boardNo) throws Exception;

	boolean insertReply(ReviewReplyDTO dto) throws Exception;

	boolean updateReply(ReviewReplyDTO dto) throws Exception;

	boolean deleteReply(int replyNo, int userId) throws Exception;

	List<ReviewReplyDTO> getRepliesByBoardNoWithPaging(int boardNo, int loginUserId, RPageRequestDTO pageRequestDTO) throws Exception;

	int getReplyCount(int boardNo) throws Exception;

	boolean likeReply(int replyNo, int userUid) throws Exception;

	boolean unlikeReply(int replyNo, int userUid) throws Exception;

}
