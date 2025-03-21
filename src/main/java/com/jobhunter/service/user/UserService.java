package com.jobhunter.service.user;

import java.util.Map;

import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.UserVO;

public interface UserService {
	
	// 일반로그인
	Map<String, Object> loginUser(LoginDTO loginDto) throws Exception;
	
	// 자동로그인
	UserVO getUserByAutoLoginToken(String token) throws Exception;

	void saveAutoLoginToken(String userId, String sessionId) throws Exception;

}
