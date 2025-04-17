package com.jobhunter.service.account;

import java.util.Map;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.findIdDTO;
import com.jobhunter.model.customenum.AccountType;

public interface AccountService {
	
	AccountVO loginAccount(LoginDTO loginDto, String sessionId) throws Exception;
	
	void setRequiresVerificationFalse(int uid, AccountType userType) throws Exception;

	AccountVO refreshAccount(int uid, AccountType type) throws Exception;

	AccountVO findAccountByAutoLogin(String sessionId, AccountType type) throws Exception;

	Boolean checkDuplicateContact(String target, AccountType type, String targetType) throws Exception;

	Map<String, Object> getIdByContect(findIdDTO dto) throws Exception;
}
