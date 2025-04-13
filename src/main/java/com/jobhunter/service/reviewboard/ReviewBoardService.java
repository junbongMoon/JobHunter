package com.jobhunter.service.reviewboard;

import java.util.List;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;

public interface ReviewBoardService {

	// 게시글 조회
	List<ReviewBoardDTO> selectReBoard() throws Exception;

	// 작성 페이지에 공고정보 조회
	List<RecruitmentnoticContentDTO> selectgoggo(int userUid, String ip) throws Exception;

	// 게시글 저장 --
	boolean saveReview(WriteBoardDTO writeBoardDTO) throws Exception;

	// 상세페이지 조회
	ReviewDetailViewDTO getReviewDetail(int boardNo) throws Exception;

	// 좋아요 기능
	boolean addlikes(int userId, int boardNo) throws Exception;

	// 좋아요 취소
	boolean removeLike(int userId, int boardNo) throws Exception;

	// 수정 조회
	WriteBoardDTO getReviewBoardUpdate(int boardNo) throws Exception;

	// 수정 저장
	boolean updateReviewBoard(WriteBoardDTO modify) throws Exception;

	void deleteBoard(int boardNo) throws Exception;

	// 조회수 조회
	boolean oneViewCount(int userId, int boardNo) throws Exception;

	// 조회수 증가
	void insertViewCount(int userId, int boardNo) throws Exception;



}
