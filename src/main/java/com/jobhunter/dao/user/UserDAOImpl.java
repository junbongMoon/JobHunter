package com.jobhunter.dao.user;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserDAOImpl implements UserDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.usermapper";
	
	@Override
	public UserVO getUserInfo(String uid) throws Exception {
		return ses.selectOne(NS+".getUserInfo", uid);
	}
}
