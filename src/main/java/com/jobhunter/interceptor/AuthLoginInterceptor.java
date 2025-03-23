package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.util.RedirectUtil;

public class AuthLoginInterceptor implements HandlerInterceptor {

	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();
        AccountVO account = (AccountVO) session.getAttribute("account");

        // 로그인 안 한 경우
        if (account == null) {
            RedirectUtil.saveRedirectUrl(request, session);
            response.sendRedirect("/account/login/return");
            return false;
        }

        // 인증 필요 여부 체크
        if ("Y".equals(account.getRequiresVerification())) {
        	response.sendRedirect(request.getContextPath() + "/account/login?requireVerification=true");
            return false;
        }

        return true;
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
}
