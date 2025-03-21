package com.jobhunter.dao.reviewboard;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j;


@Repository
@RequiredArgsConstructor
public class ReviewBoardDAOImpl {
	private final SqlSession ses;

}
