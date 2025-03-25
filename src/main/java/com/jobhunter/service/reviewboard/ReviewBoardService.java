package com.jobhunter.service.reviewboard;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;


public interface ReviewBoardService {
	
	//게시글 조회 
	List<ReviewBoard> selectReBoard() throws Exception;
	// 게시글 저장 
	boolean saveReview(ReviewBoardDTO reviewBoardDTO)throws Exception;
	
	//상세페이지 조회 
	ReviewBoard getBoardDetail(int boardNo) throws Exception;

	



}
