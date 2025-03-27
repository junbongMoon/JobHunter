package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.account.AccountService;

@Component
public class OwnerInterceptor implements HandlerInterceptor {
	
	@Autowired
	private  AccountService accountService;

	// 세션 로그인 계정 정보 새로고침 
    private AccountVO refreshAccount(AccountVO sessionAccount) {
        if (sessionAccount == null) return null;
        try {
            return accountService.refreshAccount(sessionAccount.getUid(), sessionAccount.getAccountType());
        } catch (Exception e) {
            e.printStackTrace();
            return sessionAccount; // 실패하면 원래 세션 값 그대로
        }
    }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

    	// 오직 GET + Accept: text/html 접근만 걸러냄
        boolean isGet = "GET".equalsIgnoreCase(request.getMethod());
        String accept = request.getHeader("Accept");
        boolean expectsHtml = accept != null && accept.contains("text/html");

        if (!(isGet && expectsHtml)) {
            return true; // GET + 브라우저 접근이 아니면 무시
        }
    	
    	
        HttpSession session = request.getSession();
        
        // 일단 계정 상태 서버에있는걸로 갱신좀 해서 그사이 정지먹진않았나 체크해주고
        AccountVO account = refreshAccount((AccountVO) session.getAttribute("account"));
        
        // 쿼리스트링으로부터 파라미터 추출
        int uid = Integer.parseInt(request.getParameter("uid"));
        AccountType type = AccountType.valueOf(request.getParameter("accountType").toUpperCase());
        
        String errorParam = "accessFail=notOwner";
        
        try {
        	// 이상없으면 그냥 그대로 진행
            if (account.getUid() == uid && account.getAccountType() == type) {
                return true;
            }
        } catch (Exception e) {
            // 파라미터 누락/형변환 실패 등
        	errorParam = "accessFail=checkFail";
        }

        // 문제있으면 기존페이지 링크 저장하고 쿼리스트링에 에러붙여서 돌려보내기
        String uri = request.getRequestURI();
        String query = request.getQueryString();

        String fullRedirectUrl;
        if (query == null || query.isEmpty()) {
            fullRedirectUrl = uri + "?" + errorParam;
        } else {
            fullRedirectUrl = uri + "?" + query + "&" + errorParam;
        }

        response.sendRedirect(fullRedirectUrl);
        return false;
    }

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
	}

}
