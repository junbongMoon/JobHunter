package com.jobhunter.dao.status;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.status.StatusVODTO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class StatusDAOImpl implements StatusDAO {
	
	private final SqlSession ses;
	private final String NS = "2";

	@Override
	public void insertStatusDate(StatusVODTO status) {
		ses.insert(NS + ".saveDateStatus", status);

	}

}
