package com.jobhunter.interceptor;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class AuthLoginInterceptor implements HandlerInterceptor {

	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");

        String requestUri = request.getRequestURI();
        String queryString = request.getQueryString();
        String fullUrl = requestUri + (queryString != null ? "?" + queryString : "");

        // 요청 방식 확인 (GET 여부)
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            // GET 요청이면 요청한 URL을 저장
            session.setAttribute("redirectUrl", fullUrl);
        } else {
            // 다른 요청 방식이면 Referer 헤더를 확인 (이전 페이지의 URL 저장)
            String referer = request.getHeader("Referer");
            if (referer != null) {
                session.setAttribute("redirectUrl", referer);
            } else {
                session.setAttribute("redirectUrl", "/"); // 기본 페이지
            }
        }

        // 로그인 체크
        if (user == null) {
            redirectToLogin(response, session);
            return false; // 요청 중단
        }

        return true; // 요청 진행
    }

	// 로그인 페이지로 리디렉트
    private void redirectToLogin(HttpServletResponse response, HttpSession session) throws Exception {
        response.sendRedirect("/login");
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
