package com.jobhunter.aop;


import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.jobhunter.dao.log.AccountLogDAO;
import com.jobhunter.model.account.AccountVO;

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
public class AccountLogingAdvice {
   
	/** 계정관련 로그 남기는 DAO */
	@Autowired
	private AccountLogDAO dao;
	
    /**
     * 계정 생성 로그
     * <p>
     * 계정의 회원가입이 성공적으로 끝나고 자동으로 로그인까지 진행될 때 계정의 UID와 계정타입을 참고해서 회원가입 로그를 DB에 남겨줍니다.
     * </p>
     * 
     * @param result 회원가입성공하고 자동으로 로그인되면서 돌아오는 계정(AccountVO)
     * 
     */
    @AfterReturning(
        pointcut = "execution(* com.jobhunter.service.user.UserService.registUser(..)) || " +
                    "execution(* com.jobhunter.service.company.CompanyService.registCompany(..))",
        returning = "result"
    )
   public void insertRegistrationLog(Object result) {
	   if (result instanceof AccountVO) {
		    AccountVO account = (AccountVO) result;
		    try {
		        dao.insertRegisterLog(account.getUid(), account.getAccountType());
		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}
   }
   
}
