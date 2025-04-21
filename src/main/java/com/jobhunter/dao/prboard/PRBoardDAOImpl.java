package com.jobhunter.dao.prboard;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.prboard.PRBoardDTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class PRBoardDAOImpl implements PRBoardDAO {
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.prboardmapper";

	@Override
	public int insertPRBoard(PRBoardDTO prBoardDTO) throws Exception {
		
		return ses.insert(NS +".savePRBoardByMento", prBoardDTO);
	}

}
