package com.jobhunter.dao.reviewReply;

import java.util.List;
import java.util.Map;

import com.jobhunter.model.reviewReply.ReviewReplyDTO;
import com.jobhunter.model.reviewboard.Likes;

public interface ReviewReplyDAO {
    List<ReviewReplyDTO> selectRepliesByBoardNo(int boardNo) throws Exception;
    
    
    int insertReply(ReviewReplyDTO dto) throws Exception;
    
    int updateReplyDao(ReviewReplyDTO dto) throws Exception;
    
    int deleteReplyDao(int replyNo, int userId) throws Exception;


	int countRepliesByBoardNo(int boardNo) throws Exception;
	
	
	int hasUserLikedReply(Likes like) throws Exception;


	int insertReplyLike(Likes like) throws Exception;


	int updateReplyLikes(int replyNo) throws Exception;


	int deleteReplyLike(Likes like) throws Exception;


	int decreaseReplyLikes(int replyNo) throws Exception;


	List<ReviewReplyDTO> selectRepliesWithPaging(Map<String, Object> param) throws Exception;
	

	
}
