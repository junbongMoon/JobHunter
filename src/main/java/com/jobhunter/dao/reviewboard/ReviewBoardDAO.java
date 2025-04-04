package com.jobhunter.dao.reviewboard;

import java.util.List;

import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;
import com.jobhunter.model.reviewboard.RecruitmentnoticContentDTO;


public interface ReviewBoardDAO {

	List<ReviewBoardDTO> selectListBoard() throws Exception;

	List<RecruitmentnoticContentDTO> selectWriteGonggo(int userUid)throws Exception;

	int insertBoard(WriteBoardDTO writeBoardDTO) throws Exception;

	ReviewDetailViewDTO selectReviewInfo(int boardNo) throws Exception;

	

	

}
