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
		// TODO Auto-generated method stub
		return Rdao.selectListBoard();
	}
}
