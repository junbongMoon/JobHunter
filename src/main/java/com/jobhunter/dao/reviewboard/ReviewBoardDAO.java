package com.jobhunter.dao.reviewboard;

import java.time.LocalDateTime;
import java.util.List;

import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;

public interface ReviewBoardDAO {

	List<ReviewBoardDTO> selectListBoard() throws Exception;

	List<RecruitmentnoticContentDTO> selectWriteGonggo(int userUid) throws Exception;

	int insertBoard(WriteBoardDTO writeBoardDTO) throws Exception;

	ReviewDetailViewDTO selectReviewInfo(int boardNo) throws Exception;

	LocalDateTime selectLike(int userId, int boardNo) throws Exception;

	int insertLike(int userId, int boardNo) throws Exception;

	int updateBoardLikes(int boardNo) throws Exception;

	int deleteLike(int userId, int boardNo) throws Exception;

	int decreaseBoardLikes(int boardNo) throws Exception;

	WriteBoardDTO selectrecruitmentList(int boardNo) throws Exception;

	int updateReviewBoard(WriteBoardDTO modify) throws Exception;

	void deletBoardNo(int boardNo) throws Exception;

	int checkViewedWithHours(int userId, int boardNo) throws Exception;	

	int saveViewRecord(int userId, int boardNo) throws Exception;

	int incrementViews(int boardNo) throws Exception;


}
