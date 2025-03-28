package com.jobhunter.dao.reviewboard;

import java.util.List;

import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.recruitmentnoticContentDTO;


public interface ReviewBoardDAO {

	List<ReviewBoardDTO> selectListBoard() throws Exception;

	List<recruitmentnoticContentDTO> selectWriteGonggo()throws Exception;

	int insertBoard(ReviewBoardDTO reviewBoardDTO) throws Exception;

	ReviewDetailViewDTO selectReviewInfo(int boardNo) throws Exception;

	

}
