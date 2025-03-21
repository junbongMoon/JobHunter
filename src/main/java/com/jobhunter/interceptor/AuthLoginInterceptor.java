package com.jobhunter.interceptor;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;

public class AuthLoginInterceptor implements HandlerInterceptor {
	
	@Autowired
	private UserService userService;

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	    HttpSession session = request.getSession();
	    Object user = session.getAttribute("user");

	    // 1차 로그인 체크
	    if (user == null) {
	        // 쿠키확인
	        Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	        	//쿠키에서 자동로그인이 있냐
	            for (Cookie cookie : cookies) {
	                if ("autoLogin".equals(cookie.getName())) {
	                    String autoLoginToken = cookie.getValue();

	                    // 자동로그인
	                    UserVO autoUser = userService.getUserByAutoLoginToken(autoLoginToken);

	                    if (autoUser != null) {
	                        session.setAttribute("user", autoUser); // 자동 로그인 성공
	                        break;
	                    }
	                }
	                // 카톡로그인 자동 추가하면 여기에 else로 카톡토큰 체크넣으면 될듯?
	                
	            }
	        }
	    }

	    user = session.getAttribute("user");

	    // 요청 URL 저장 (로그인 후 이동용)
	    String requestUri = request.getRequestURI();
	    String queryString = request.getQueryString();
	    String fullUrl = requestUri + (queryString != null ? "?" + queryString : "");
	    

	    if ("GET".equalsIgnoreCase(request.getMethod())) {
	        session.setAttribute("redirectUrl", fullUrl);
	    } else {
	        String referer = request.getHeader("Referer");
	        session.setAttribute("redirectUrl", referer != null ? referer : "/");
	    }

	    // 최종에최종 로그인 체크
	    if (user == null) {
	        response.sendRedirect("/user/login");
	        return false;
	    }

	    return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub

	}

}
