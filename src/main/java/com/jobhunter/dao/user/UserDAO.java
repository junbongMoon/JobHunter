package com.jobhunter.dao.user;

import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;

public interface UserDAO {

	String isAuthVerifi(String userId) throws Exception;

	AccountVO loginUser(LoginDTO logindto) throws Exception;
	
	void increaseFailCount(String userId) throws Exception;
	
	int getFailCount(String userId) throws Exception;
	
	void setRequiresVerification(String userId) throws Exception;

	void resetFailCount(String userId) throws Exception;
	
	void setRequiresVerificationFalse(Map<String, String> param) throws Exception;

	Boolean existsUserId(String userId) throws Exception;

}
