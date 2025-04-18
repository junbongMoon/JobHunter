package com.jobhunter.util;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.account.AccountService;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class AccountUtil {
	
	private final AccountService accountService;

	// 로그인된 계정 새로고침
	public AccountVO refreshAccount(AccountVO sessionAccount) {
		if (sessionAccount == null) {
			return null;
		}

		int uid = sessionAccount.getUid();
		AccountType type = sessionAccount.getAccountType();

		try {
			return accountService.refreshAccount(uid, type);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return sessionAccount;
		}
	}
	
	public Boolean checkUid(HttpSession session, int uid) {
		AccountVO sessionAccount = (AccountVO) session.getAttribute("account");
		
		return sessionAccount != null && sessionAccount.getUid() == uid;
	}
}
