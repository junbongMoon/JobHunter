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

	@Override
	public void saveAutoLoginToken(String userId, String sessionId) throws Exception {
	    Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("sessionId", sessionId);
	    ses.update(NS + ".saveAutoLoginToken", param);
	}

	@Override
	public UserVO getUserByAutoLoginToken(String sessionId) throws Exception {
	    return ses.selectOne(NS + ".getUserByAutoLoginToken", sessionId);
	}

	// 로그아웃 아직 안만들었는데 어차피 해야되니까 미리 만들어둠
	// 어차피 로그아웃에서 유저는 세션에서 빼는거라 DB할건 없고
	// 이건 자동로그인에 넣어둔 세션아이디만 지우는거
	@Override
	public void removeAutoLoginToken(String userId) throws Exception {
	    ses.update(NS + ".removeAutoLoginToken", userId);
	}


}
