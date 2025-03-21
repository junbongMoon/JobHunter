package com.jobhunter.dao.user;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.user.User;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserDAOImpl implements UserDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.usermapper";

	@Override
	public void insertUser() throws Exception {
		String a = ses.selectOne(NS + ".now");
		
		System.out.println(a); 
	}

}
