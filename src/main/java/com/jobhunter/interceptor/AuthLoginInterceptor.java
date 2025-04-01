package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.util.RedirectUtil;

@Component
public class AuthLoginInterceptor implements HandlerInterceptor {

	@Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        HttpSession session = request.getSession();
        AccountVO account = (AccountVO) session.getAttribute("account");

        // AJAX, Fetch, Axios 등 체크
        boolean isAsync = isAsyncOrApiRequest(request); 
        
        // 로그인 안 한 경우
        if (account == null) {
            RedirectUtil.saveRedirectUrl(request, session);
            
            String loginUrl = request.getContextPath() + "/account/login/return";
            
            if (isAsync) {
                response.setContentType("application/json; charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"NEED_LOGIN\", \"redirect\": \"" + loginUrl + "\"}");
            } else {
                response.sendRedirect(loginUrl);
            }
            
            return false;
        }

        // 인증 필요 여부 체크
        if ("Y".equals(account.getRequiresVerification())) {
        	String redirectUrl = request.getContextPath() + "/account/login?requireVerification=true";

            if (isAsync) {
                response.setContentType("application/json; charset=UTF-8");
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"NEED_VERIFICATION\", \"redirect\": \"" + redirectUrl + "\"}");
            } else {
                response.sendRedirect(redirectUrl);
            }
            
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
	
	private boolean isAsyncOrApiRequest(HttpServletRequest request) {
	    String requestedWith = request.getHeader("X-Requested-With");
	    String accept = request.getHeader("Accept");

	    return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
	        || (accept != null && accept.contains("application/json"));
	}
}
