package com.jobhunter.service.reviewReply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.reviewReply.ReviewReplyDAO;
import com.jobhunter.model.reviewReply.ReviewReplyDTO;
import com.jobhunter.model.reviewboard.Likes;
import com.jobhunter.model.reviewboard.RPageRequestDTO;

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

	@Override
    public List<ReviewReplyDTO> getRepliesByBoardNoWithPaging(int boardNo, int loginUserId,
			RPageRequestDTO pageRequestDTO) throws Exception {
		Map<String, Object> param = new HashMap<>();
	    param.put("boardNo", boardNo);
	    param.put("offset", pageRequestDTO.getOffset());
	    param.put("size", pageRequestDTO.getSize());
	    param.put("loginUserId", loginUserId);  
		
		
		return replyDAO.selectRepliesWithPaging(param);
    }

    @Override
    public int getReplyCount(int boardNo) throws Exception {
        return replyDAO.countRepliesByBoardNo(boardNo);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean likeReply(int replyNo, int userUid) throws Exception {
        Likes like = Likes.builder()
        		.userId(userUid)
                .boardNo(replyNo) 
                .likeType("REPLY")
                .build();

        // 1. 좋아요 기록 확인
        int hasLiked = replyDAO.hasUserLikedReply(like);
        if (hasLiked > 0) {
            return false; // 이미 좋아요한 경우
        }

        // 2. 좋아요 등록 (로그 + 댓글 테이블 좋아요 수 증가)
        int insertResult = replyDAO.insertReplyLike(like);
        int updateResult = replyDAO.updateReplyLikes(replyNo);

        return insertResult > 0 && updateResult > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean unlikeReply(int replyNo, int userUid) throws Exception {
        Likes like = Likes.builder()
                .userId(userUid)
                .boardNo(replyNo) 
                .likeType("REPLY")
                .build();

        // 1. 좋아요 여부 확인
        int hasLiked = replyDAO.hasUserLikedReply(like);
        if (hasLiked == 0) {
            return false; // 좋아요 하지 않았던 경우
        }

        // 2. 좋아요 취소 (로그 삭제 + 댓글 테이블 좋아요 수 감소)
        int deleteResult = replyDAO.deleteReplyLike(like);
        int updateResult = replyDAO.decreaseReplyLikes(replyNo);

        return deleteResult > 0 && updateResult > 0;
    }




}
