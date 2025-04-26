package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.customexception.NeedAuthException;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.UnlockDTO;
import com.jobhunter.util.AccountUtil;
import com.jobhunter.util.RedirectUtil;

@Component
public class AuthLoginInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		HttpSession session = request.getSession();
		AccountVO account = AccountUtil.getAccount(session);

		if (account != null) {
			if ("N".equals(account.getRequiresVerification())) {
				return true;
			} else if ("Y".equals(account.getRequiresVerification())) {
				session.setAttribute("unlockDTO", new UnlockDTO(account));
			}
		}
		// 로그인 안 했거나 인증이 필요할 때
		RedirectUtil.saveRedirectUrl(request, session);

		if (RedirectUtil.isApiRequest(request)) { // 비동기면 에러코드 보내서 뷰단에서 알아서 로그인페이지로 보내도록 유도
			System.out.println("혹시 여기 왔냐?");
			NeedAuthException.writeToAuthResponse(response);
			response.flushBuffer();
		} else {
			System.out.println("아님 여기?");
			response.sendRedirect(request.getContextPath() + "/account/login");
		}

		return false;

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
