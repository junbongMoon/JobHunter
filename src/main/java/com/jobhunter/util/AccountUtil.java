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
	
	public boolean checkOwnershipOrAdmin(AccountVO acc, boolean isAdminAllowed, Object... conditions) {
	    if (conditions.length % 2 != 0) {
	         System.out.println("AccountUtil.checkOwnershipOrAdmin_조건은 uid와 AccountType의 쌍으로 입력되어야 합니다.");
	    }

	    // 관리자 우선 패스
	    if ("Y".equalsIgnoreCase(acc.getIsAdmin())) return true;

	    for (int i = 0; i < conditions.length; i += 2) {
	        Object uidObj = conditions[i];
	        Object typeObj = conditions[i + 1];

	        if (!(uidObj instanceof Integer) || !(typeObj instanceof AccountType)) {
	            throw new IllegalArgumentException("조건은 (Integer uid, AccountType type) 쌍이어야 합니다.");
	        }

	        int allowedUid = (int) uidObj;
	        AccountType allowedType = (AccountType) typeObj;

	        if (acc.getUid() == allowedUid && acc.getAccountType() == allowedType) {
	            return true;
	        }
	    }

	    return false;
	}
}
