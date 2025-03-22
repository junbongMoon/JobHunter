package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.util.RedirectUtil;

public class AuthLoginInterceptor implements HandlerInterceptor {

	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");

        // 로그인 안 한 경우
        if (user == null) {
            RedirectUtil.saveRedirectUrl(request, session);
            response.sendRedirect("/user/go-login");
            return false;
        }

        // 인증 필요 여부 체크
        Boolean needsVerification = (Boolean) session.getAttribute("requiresVerification");
        if (Boolean.TRUE.equals(needsVerification)) {
            RedirectUtil.saveRedirectUrl(request, session);
            response.sendRedirect("/user/login?requireVerification=true");
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
