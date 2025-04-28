package com.jobhunter.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
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
			e.printStackTrace();
			return sessionAccount;
		}
	}

	// sessionAccount의 권한이 allowType과 맞으면 true
	public static boolean checkType(AccountType allowType, AccountVO sessionAccount) {
		List<AccountType> allowTypes = new ArrayList<AccountType>();
		allowTypes.add(allowType);
		return checkType(allowTypes, sessionAccount);
	}

	// sessionAccount의 권한이 allowTypes중 하나라도 맞으면 true
	public static boolean checkType(List<AccountType> allowTypes, AccountVO sessionAccount) {
		if (sessionAccount == null) {
			return false;
		}

		if (allowTypes != null && !allowTypes.isEmpty()) {
			// 관리자 우선 패스
			if (allowTypes.contains(AccountType.ADMIN) && "Y".equalsIgnoreCase(sessionAccount.getIsAdmin())) {
				return true;
			}

			// 멘토 체크
			if (allowTypes.contains(AccountType.MENTOR) && "Y".equalsIgnoreCase(sessionAccount.getIsMentor())) {
				return true;
			}

			// 나머지 역할
			return allowTypes.contains(sessionAccount.getAccountType());

		}

		return false;
	}
	
	// uids중 하나라도 sessionAccount의 uid와 같은게 있는지 비교(계정타입 비교 없음_무조건 개인 혹은 무조건 기업으로 고정되어있을때 사용)
	public static boolean checkUid(AccountVO sessionAccount, int... uids) {
		List<AccountType> allowTypes = new ArrayList<AccountType>();
		return checkUid(allowTypes, sessionAccount, uids);
	}
	
	// sessionAccount의 권한이 allowTypes중 하나라도 맞거나
	// uids중 하나라도 sessionAccount의 uid와 같은게 있는지 비교(계정타입 비교 없음_무조건 개인 혹은 무조건 기업으로 고정되어있을때 사용)
	public static boolean checkUid(List<AccountType> allowTypes, AccountVO sessionAccount, int... uids) {
		if (sessionAccount == null) {
			return false;
		}

		if (allowTypes != null && !allowTypes.isEmpty()) {
	    	// 관리자 우선 패스
		    if (allowTypes.contains(AccountType.ADMIN) && "Y".equalsIgnoreCase(sessionAccount.getIsAdmin())) {
		    	return true;
		    }
		    
		    // 멘토 체크
		    if (allowTypes.contains(AccountType.MENTOR) && "Y".equalsIgnoreCase(sessionAccount.getIsMentor())) {
		    	return true;
		    }
		    
	    }
	    
	    for (int uid : uids) {
	        if (sessionAccount.getUid() == uid) {
	            return true;
	        }
	    }
	    
		return false;
	}
	
	public static boolean checkAuth(AccountVO sessionAccount, Object... conditions) {
		List<AccountType> allowTypes = new ArrayList<AccountType>();
		return checkAuth(allowTypes, sessionAccount, conditions);
	}
	
	public static boolean checkAuth(AccountType allowType, AccountVO sessionAccount, Object... conditions) {
		List<AccountType> allowTypes = new ArrayList<AccountType>();
		allowTypes.add(allowType);
		return checkAuth(allowTypes, sessionAccount, conditions);
	}
	
	public static boolean checkAuth(List<AccountType> allowTypes, AccountVO sessionAccount, Object... conditions) {
		if (sessionAccount == null) {
			return false;
		}

	    if (conditions.length % 2 != 0) {
	         System.out.println("AccountUtil.checkOwnershipOrAdmin_조건은 uid와 AccountType의 쌍으로 입력되어야 합니다.");
	         return false;
	    }
	    
	    if (allowTypes != null && !allowTypes.isEmpty()) {
	    	// 관리자 우선 패스
		    if (allowTypes.contains(AccountType.ADMIN) && "Y".equalsIgnoreCase(sessionAccount.getIsAdmin())) {
		    	return true;
		    }
		    
		    // 멘토 체크
		    if (allowTypes.contains(AccountType.MENTOR) && "Y".equalsIgnoreCase(sessionAccount.getIsMentor())) {
		    	return true;
		    }
	    }
	    

	    for (int i = 0; i < conditions.length; i += 2) {
	        Object uidObj = conditions[i];
	        Object typeObj = conditions[i + 1];

	        if (!(uidObj instanceof Integer) || !(typeObj instanceof AccountType)) {
	        	System.out.println("AccountUtil.checkOwnershipOrAdmin_조건은 (Integer uid, AccountType type) 쌍이어야 합니다.");
	            return false;
	        }

	        int allowedUid = (int) uidObj;
	        AccountType allowedType = (AccountType) typeObj;

	        if (sessionAccount.getUid() == allowedUid && sessionAccount.getAccountType() == allowedType) {
	            return true;
	        }
	    }

	    return false;
	}
	
	public static AccountVO getAccount(HttpServletRequest request) {
		return getAccount(request.getSession());
	}
	
	public static AccountVO getAccount(HttpSession session) {
		return (AccountVO) session.getAttribute("account");
	}
}
