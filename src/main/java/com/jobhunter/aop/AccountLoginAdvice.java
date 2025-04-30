package com.jobhunter.aop;

import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.resume.ResumeService;

/**
 * 계정 관련 로그 남겨주는 AOP
 * <p>
 * UID와 계정타입을 통해서 로그테이블에 로그를 남겨줍니다.
 * </p>
 * 
 * @author 육근우
 */
@Component
@Aspect
public class AccountLoginAdvice {

	@Autowired
	private ResumeService resumeService;

	/**
	 * 로그인 시 본인관련 기한있는 신청서 만료
	 * <p>
	 * 계정의 로그인이 성공적으로 끝나면 본인의 첨삭신청과 같은 유효기간 지난 항목들 만료처리
	 * </p>
	 * 
	 * @param result 로그인 성공시 받아오는 계정 정보
	 * 
	 */
	@AfterReturning(pointcut = "execution(* com.jobhunter.service.account.AccountService.loginAccount(..))", returning = "result")
	public void expireRegistrationAdvice(Object result) {
		if (result instanceof AccountVO) {
		    AccountVO account = (AccountVO) result;
		    if (account != null && account.getAccountType() == AccountType.USER) {
		    	try {
			    	resumeService.expireRegistrationAdvice(account);
			    } catch (Exception e) {
			        e.printStackTrace();
			    }
		    }
		}
		
	}

}
