package com.jobhunter.dao.reviewboard;

import java.util.List;

import com.jobhunter.model.reviewboard.GonggoContentDTO;
import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;


public interface ReviewBoardDAO {

	List<ReviewBoardDTO> selectListBoard() throws Exception;

	List<GonggoContentDTO> selectWriteGonggo()throws Exception;

	int insertBoard(ReviewBoardDTO reviewBoardDTO) throws Exception;

	ReviewDetailViewDTO selectReviewInfo(int boardNo) throws Exception;

	

}
