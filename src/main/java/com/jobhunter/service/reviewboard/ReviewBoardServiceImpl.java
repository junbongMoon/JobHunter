package com.jobhunter.service.reviewboard;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewBoardServiceImpl implements ReviewBoardService {

	private final ReviewBoardDAO Rdao;
	
	private static Logger logger = LoggerFactory.getLogger(ReviewBoardServiceImpl.class);
	



	@Override
	public List<ReviewBoard> selectReBoard() throws Exception {


		return Rdao.selectListBoard();
	}




	@Override
	public boolean saveReview(ReviewBoardDTO reviewBoardDTO) throws Exception {
	    boolean result = false;
	    int boardInt = Rdao.insertBoard(reviewBoardDTO);

	    System.out.println("insertBoard() 결과: " + boardInt);

	    if (boardInt > 0) {
	        System.out.println("리뷰 등록 성공");
	        result = true;
	    } else {
	        System.out.println("리뷰 등록 실패");
	    }

	    return result;
	}




	@Override
	public ReviewBoard getBoardDetail(int boardNo) throws Exception {
		
		return Rdao.selectDetailBoard(boardNo);
	}
}
