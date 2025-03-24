package com.jobhunter.dao.reviewboard;

import java.util.List;

import com.jobhunter.model.reviewboard.ReviewBoard;

public interface ReviewBoardDAO {

	List<ReviewBoard> selectListBoard() throws Exception;

	

}
