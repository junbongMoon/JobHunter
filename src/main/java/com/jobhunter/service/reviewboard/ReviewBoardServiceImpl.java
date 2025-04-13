package com.jobhunter.service.reviewboard;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewBoardServiceImpl implements ReviewBoardService {

	private final ReviewBoardDAO Rdao;

	private static Logger logger = LoggerFactory.getLogger(ReviewBoardServiceImpl.class);

	@Override
	public List<ReviewBoardDTO> selectReBoard() throws Exception {

		return Rdao.selectListBoard();
	}

	@Override
	public List<RecruitmentnoticContentDTO> selectgoggo(int userUid, String ip) throws Exception {
		if (userUid > 0) {
			List<RecruitmentnoticContentDTO> list = Rdao.selectWriteGonggo(userUid);

			for (RecruitmentnoticContentDTO dto : list) {
				System.out.println("ip: " + dto);
			}
		} else {
			System.out.println("유효하지 않은 사용자 ID입니다.");
		}
		return Rdao.selectWriteGonggo(userUid);
	}

	@Override
	public boolean saveReview(WriteBoardDTO writeBoardDTO) throws Exception {
		boolean result = false;
		int boardInsert = Rdao.insertBoard(writeBoardDTO);

		System.out.println("insertBoard() 결과: " + boardInsert);

		if (boardInsert > 0) {
			System.out.println("리뷰 등록 성공");
			result = true;
		} else {
			System.out.println("리뷰 등록 실패");
		}

		return result;
	}

	@Override
	public ReviewDetailViewDTO getReviewDetail(int boardNo) throws Exception {

		return Rdao.selectReviewInfo(boardNo);
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, isolation = Isolation.DEFAULT, rollbackFor = Exception.class)
	public boolean addlikes(int userId, int boardNo) throws Exception {

		// 1. 마지막 좋아요 시간 조회-> 유저가(userId) 어떤 게시글(boardNo)에 마지막으로 좋아요를 누른 시간이 언제인지
		LocalDateTime lastLikeTime = Rdao.selectLike(userId, boardNo);

		// 2. 24시간 제한 체크
		// if문으로 마지막으로 좋아요 누른 시간이 있다면
		if (lastLikeTime != null) {
			// 현재 날짜와 시간을 now에 저장
			LocalDateTime now = LocalDateTime.now();
			// 마지막 좋아요 시간(lastLikeTime)과 지금 시간(now) 사이의 시간 차이를 계산
			// ChronoUnit: 날짜나 시간 사이의 차이를 계산할 때,사용할 단위를 지정해주는 도구
			// HOURS는 시간을 기준으로 할때 between은 (A변수,B변수) 의 차이를 시간알려준다
			long hours = ChronoUnit.HOURS.between(lastLikeTime, now);
			// 마지막 좋아요 이후 24시간이 지나지 않았다면
			if (hours < 24) {
				throw new IllegalArgumentException("24시간 이내에 같은 게시글에 좋아요를 할 수 없습니다.");
			}
		}

		// 3. 좋아요 추가

		Rdao.insertLike(userId, boardNo);

		// 4. 게시글 좋아요 수 증가
		Rdao.updateBoardLikes(boardNo);

		return true;
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public boolean removeLike(int userId, int boardNo) throws Exception {
		int result = Rdao.deleteLike(userId, boardNo);
		if (result > 0) {
			Rdao.decreaseBoardLikes(boardNo);
			return true;
		}
		return false;
	}

	@Override
	public WriteBoardDTO getReviewBoardUpdate(int boardNo) throws Exception {
		
		return Rdao.selectrecruitmentList(boardNo);
	}


	@Override
	public boolean updateReviewBoard(WriteBoardDTO modify) throws Exception {
	    int result = Rdao.updateReviewBoard(modify);

	    if (result > 0) {
	        return true; // 수정 성공
	    }
	    return false ; // 수정 실패
	}

	@Override
	public void deleteBoard(int boardNo) throws Exception {
			
		Rdao.deletBoardNo(boardNo);
		
	}
	
	@Override
	public boolean oneViewCount(int userId, int boardNo) throws Exception {
		int count = Rdao.checkViewedWithHours(userId, boardNo);
	    return count == 0;  //조회 기록이 없다
	}

	@Transactional
	public void insertViewCount(int userId, int boardNo)throws Exception {
		int count = Rdao.checkViewedWithHours(userId, boardNo);
	    if (count == 0) {
	    	Rdao.saveViewRecord(userId, boardNo); 
	    	Rdao.incrementViews(boardNo);     
	    }

	}

}
