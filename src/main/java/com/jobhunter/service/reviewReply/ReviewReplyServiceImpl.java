package com.jobhunter.service.reviewReply;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.dao.reviewReply.ReviewReplyDAO;
import com.jobhunter.model.reviewReply.ReviewReplyDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewReplyServiceImpl implements ReviewReplyService {

	private final ReviewReplyDAO replyDAO;

	@Override
	public List<ReviewReplyDTO> getRepliesByBoardNo(int boardNo) throws Exception {
		return replyDAO.selectRepliesByBoardNo(boardNo);
	}

	@Override
	public boolean insertReply(ReviewReplyDTO dto) throws Exception {
		int result = replyDAO.insertReply(dto);

		if (result > 0) {
			return true; // 성공적으로 삽입됨
		} else {
			return false;
		}
	}
	
	@Override
	public boolean updateReply(ReviewReplyDTO dto) throws Exception {
		int result = replyDAO.updateReplyDao(dto);
	    if (result == 1) {
	        return true;
	    } else {
	        return false;
	    }
	}

	@Override
	public boolean deleteReply(int replyNo, int userId) throws Exception {
		int result = replyDAO.deleteReplyDao(replyNo, userId);
	    if (result == 1) {
	        return true;
	    } else {
	        return false;
	    }
	}
}
