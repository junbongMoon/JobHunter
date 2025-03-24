package com.jobhunter.dao.reviewboard;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.reviewboard.ReviewBoard;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;


@Repository
 class ReviewBoardDAOImpl implements ReviewBoardDAO{
	
	private static Logger logger = LoggerFactory.getLogger(ReviewBoardDAOImpl.class);
	private static final String NS = "com.jobhunter.mapper.reviewboardmapper";

	@Autowired
	private SqlSession ses;
	

	
	@Override
	public List<ReviewBoard> selectListBoard() throws Exception {
		
		return ses.selectList(NS +".allList");
	}
}
