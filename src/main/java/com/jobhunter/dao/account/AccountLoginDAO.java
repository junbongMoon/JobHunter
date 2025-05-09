package com.jobhunter.dao.account;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.findIdDTO;

public interface AccountLoginDAO {

	String isAuthVerifi(String accountId) throws Exception;

	AccountVO loginAccount(LoginDTO logindto) throws Exception;
	
	void increaseFailCount(String accountId) throws Exception;
	
	int getFailCount(String accountId) throws Exception;
	
	void setRequiresVerification(String accountId) throws Exception;

	void resetFailCount(String accountId) throws Exception;
	
	int setRequiresVerificationFalse(int uid) throws Exception;

	Boolean existsAccountId(String accountId) throws Exception;

	AccountVO getAccountByUid(int uid) throws Exception;

	void setAutoLogin(LoginDTO loginDto) throws Exception;

	void setLoginTime(int uid) throws Exception;

	AccountVO getAccountByAutoLogin(String sessionId) throws Exception;

	AccountVO findAccountByContact(String target, String targetType) throws Exception;
	
	AccountVO getIdByContect(findIdDTO dto) throws Exception;

    default AccountVO getAccountByAutoKakao(String kakaoId) throws Exception {
        throw new UnsupportedOperationException("getAccountByAutoKakao는 지원되지 않는 구현체입니다.");
    }

}
