package com.jobhunter.dao.account;

import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;

public interface AccountLoginDAO {

	String isAuthVerifi(String accountId) throws Exception;

	AccountVO loginAccount(LoginDTO logindto) throws Exception;
	
	void increaseFailCount(String accountId) throws Exception;
	
	int getFailCount(String accountId) throws Exception;
	
	void setRequiresVerification(String accountId) throws Exception;

	void resetFailCount(String accountId) throws Exception;
	
	void setRequiresVerificationFalse(Map<String, String> param) throws Exception;

	Boolean existsAccountId(String accountId) throws Exception;

}
