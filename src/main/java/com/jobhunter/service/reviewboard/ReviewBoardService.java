package com.jobhunter.service.reviewboard;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;



public interface ReviewBoardService {
	
	//게시글 조회 
	List<ReviewBoardDTO> selectReBoard() throws Exception;
	// 게시글 저장 
	boolean saveReview(ReviewBoardDTO reviewBoardDTO)throws Exception;
	
	//상세페이지 조회 
	ReviewDetailViewDTO getReviewDetail(int boardNo)throws Exception;

	



}
