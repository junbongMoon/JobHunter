package com.jobhunter.dao.user;

import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.UserVO;

public interface UserDAO {

	String isAuthVerifi(String userId) throws Exception;

	UserVO loginUser(LoginDTO logindto) throws Exception;
	
	void increaseFailCount(String userId) throws Exception;
	
	int getFailCount(String userId) throws Exception;
	
	void setRequiresVerification(String userId, String isverifi) throws Exception;

	void resetFailCount(String userId) throws Exception;

	void saveAutoLoginToken(String userId, String sessionId) throws Exception;
	
	UserVO getUserByAutoLoginToken(String sessionId) throws Exception;

	void removeAutoLoginToken(String userId) throws Exception;

}
