package com.jobhunter.service.like;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.like.LikeDAO;
import com.jobhunter.dao.recruitmentnotice.RecruitmentNoticeDAO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class LikeServiceImpl implements LikeService {
	
	private final LikeDAO likeDAO;
	private final RecruitmentNoticeDAO recDAO;


	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 게시물의 좋아요 갯수를 조회하는 메서드
	 * </p>
	 * 
	 * @param uid 게시물 pk
	 * @param boardType 게시물 타입
	 * @return 좋아요 갯수
	 * @throws Exception
	 *
	 */
	public int getLikeCntByRecruitment(int uid, String boardType) throws Exception {
	    return likeDAO.selectLikeCnt(uid, boardType);
	}

	@Override
	public boolean hasLiked(int userId, int uid, String boardType) throws Exception {
	    return likeDAO.selectHasLike(userId, uid, boardType) > 0;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public boolean saveLike(int userId, int uid, String boardType) throws Exception {
		boolean result = false;
		
		if(likeDAO.insertLikeLog(userId, uid, boardType) > 0) {
			
			if(recDAO.increaseRecruitmentLikeCnt(uid) > 0 ) {
				result = true;
			}
		}
		
	    return result;
	}
	
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	@Override
	public boolean deleteLike(int userId, int uid, String boardType) throws Exception {
		boolean result = false;
		if(likeDAO.deleteLikeLog(userId, uid, boardType) > 0) {
			if(recDAO.decreaseRecruitmentLikeCnt(uid) > 0) {
				result = true;
			}		
			
		}
	    return result;
	}

}
