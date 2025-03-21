package com.jobhunter.dao.user;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.UserVO;

import lombok.RequiredArgsConstructor;

@Repository
@RequiredArgsConstructor
public class UserDAOImpl implements UserDAO {
	
	private final SqlSession ses;
	private final String NS = "com.jobhunter.mapper.usermapper";

	@Override
	public String isAuthVerifi(String userId) throws Exception {
		return ses.selectOne(NS+"isAuthVerifi", userId);
	}
	
	@Override
	public UserVO loginUser(LoginDTO logindto) throws Exception {
		return ses.selectOne(NS+"loginUser", logindto);
	}

	@Override
	public void increaseFailCount(String userId) throws Exception {
		ses.update(NS + ".increaseFailCount", userId);
	}

	@Override
	public int getFailCount(String userId) throws Exception {
	    return ses.selectOne(NS + ".getFailCount", userId);
	}
	
	// 인증필요여부 바꾸기_Y가 인증 필요한거
	@Override
	public void setRequiresVerification(String userId, String isverifi) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("isverifi", isverifi); // 'Y' or 'N'
	    
	    ses.update(NS + ".setRequiresVerification", param);
	}

	@Override
	public void resetFailCount(String userId) throws Exception {
		ses.update(NS + ".resetFailCount", userId);
	}


}
