package com.jobhunter.service.account;

import java.util.Map;

import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.customenum.AccountType;

public interface AccountService {
	
	Map<String, Object> loginAccount(LoginDTO loginDto) throws Exception;
	
	void setRequiresVerificationFalse(String type, String value, AccountType userType) throws Exception;
}
