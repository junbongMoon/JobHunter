package com.jobhunter.service.account;

import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.customenum.AccountType;

public interface AccountService {
	
	Map<String, Object> loginAccount(LoginDTO loginDto, String sessionId) throws Exception;
	
	void setRequiresVerificationFalse(String type, String value, AccountType userType) throws Exception;

	AccountVO refreshAccount(int uid, AccountType type) throws Exception;

	AccountVO findAccountByAutoLogin(String sessionId, AccountType type) throws Exception;

	Boolean checkDuplicateEmail(String email, AccountType type) throws Exception;

	Boolean checkDuplicateMobile(String mobile, AccountType type) throws Exception;
}
