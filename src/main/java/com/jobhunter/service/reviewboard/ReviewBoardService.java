package com.jobhunter.service.reviewboard;

import java.util.List;

import org.springframework.stereotype.Service;

import com.jobhunter.model.reviewboard.ReviewBoard;
import com.jobhunter.model.reviewboard.ReviewBoardDTO;


public interface ReviewBoardService {

	List<ReviewBoard> selectReBoard() throws Exception;



}
