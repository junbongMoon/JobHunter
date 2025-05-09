package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.customexception.NeedAuthException;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.util.AccountUtil;
import com.jobhunter.util.RedirectUtil;

@Component
public class MentorRoleInterceptor implements HandlerInterceptor {

	@Autowired
	private AccountUtil accUtils;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		AccountVO account = AccountUtil.getAccount(request);
		if (account != null) {
			// 계정 상태 서버에있는걸로 갱신
			account = accUtils.refreshAccount(account);

			if (account.getIsMentor().equals("Y")) {
				return true;
			}
		}
		
		if (RedirectUtil.isApiRequest(request)) { // 비동기 체크
			NeedAuthException.writeToAuthResponse(response); // 비동기는 에러코드보고 뷰단에서 처리
		} else {
			response.sendRedirect(RedirectUtil.getFailedRefererUrl(request));
		}
		
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
