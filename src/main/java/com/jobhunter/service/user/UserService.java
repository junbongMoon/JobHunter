package com.jobhunter.service.user;

import java.util.Map;

import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.user.UserVO;

public interface UserService {
	// 유저를 저장하는
	boolean saveUser(UserVO user) throws Exception;

	Map<String, Object> loginUser(LoginDTO loginDto) throws Exception;
	
	void setRequiresVerificationFalse(String type, String value) throws Exception;
}
