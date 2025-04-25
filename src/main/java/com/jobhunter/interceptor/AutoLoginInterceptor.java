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
					if ("kakaoAutoLogin".equals(name)) {
						String kakaoId = cookie.getValue();

						AccountVO account = accountService.findAccountByAutoKakao(kakaoId);
						if (session != null && account != null) {
							session.setAttribute("account", account);
							return true;
						}

					}
					
					if ("userAutoLogin".equals(name) || "companyAutoLogin".equals(name)) {
						String sessionId = cookie.getValue();
						AccountType type = ("userAutoLogin".equals(name)) ? AccountType.USER : AccountType.COMPANY;

						AccountVO account = accountService.findAccountByAutoLogin(sessionId, type);
						if (session != null && account != null) {
							session.setAttribute("account", account);
							return true;
						}

					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		return true; // 자동 로그인 쿠키 없음

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
