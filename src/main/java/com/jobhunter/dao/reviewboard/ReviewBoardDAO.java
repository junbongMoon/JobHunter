package com.jobhunter.dao.reviewboard;

import java.util.List;

import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;

public interface ReviewBoardDAO {

	List<ReviewBoard> selectListBoard() throws Exception;

	int insertBoard(ReviewBoardDTO reviewBoardDTO) throws Exception;

	

}
