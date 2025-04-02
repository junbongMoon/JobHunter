package com.jobhunter.interceptor;

import javax.servlet.http.Cookie;
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
import com.jobhunter.util.RedirectUtil;

@Component
public class AutoLoginInterceptor implements HandlerInterceptor {

	@Autowired
    private AccountService accountService;
	
	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();
        
        if (session != null && session.getAttribute("account") != null) {
            return true; // 이미 로그인 되어 있음
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                String name = cookie.getName();
                
                try {
                	if ("userAutoLogin".equals(name) || "companyAutoLogin".equals(name)) {
                		String sessionId = cookie.getValue();
                		AccountType type = ("userAutoLogin".equals(name))?AccountType.USER:AccountType.COMPANY;

                        AccountVO account = accountService.findAccountByAutoLogin(sessionId, type);
                        if (account != null) {
                            // 새 세션 생성 또는 기존 세션 사용
                        	session.setAttribute("account", account);
                            return true;
                        }
                    
                	}
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        return true; // 자동 로그인 쿠키 없음 → 그냥 넘김
        
    }

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		
	}
	
	private boolean isAsyncOrApiRequest(HttpServletRequest request) {
	    String requestedWith = request.getHeader("X-Requested-With");
	    String accept = request.getHeader("Accept");

	    return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
	        || (accept != null && accept.contains("application/json"));
	}
}
