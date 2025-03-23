package com.jobhunter.dao.account;

import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;

public interface AccountLoginDAO {

	String isAuthVerifi(String userId) throws Exception;

	AccountVO loginAccount(LoginDTO logindto) throws Exception;
	
	void increaseFailCount(String userId) throws Exception;
	
	int getFailCount(String userId) throws Exception;
	
	void setRequiresVerification(String userId) throws Exception;

	void resetFailCount(String userId) throws Exception;
	
	void setRequiresVerificationFalse(Map<String, String> param) throws Exception;

	Boolean existsAccountId(String userId) throws Exception;

}
