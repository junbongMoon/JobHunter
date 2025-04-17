package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.customexception.NeedLoginException;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.UnlockDTO;
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
        
        // 로그인 안 했거나 인증이 필요할 때
        if (account == null || "Y".equals(account.getRequiresVerification())) {
            RedirectUtil.saveRedirectUrl(request, session);
            
            if(account != null) {
    	        session.setAttribute("unlockDTO", new UnlockDTO(account));
            }
            
            if (isAsync) { // 비동기면 에러코드 보내서 뷰단에서 알아서 로그인페이지로 보내도록 유도
                NeedLoginException.writeToResponse(response);
            } else {
                response.sendRedirect(request.getContextPath() + "/account/login");
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
