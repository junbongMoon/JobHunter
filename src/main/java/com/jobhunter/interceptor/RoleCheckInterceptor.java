package com.jobhunter.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.util.AccountUtil;
import com.jobhunter.util.RedirectUtil;

@Component
public class RoleCheckInterceptor implements HandlerInterceptor {

    @Autowired
    private AccountUtil accUtils;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        // 오직 GET + Accept: text/html 접근만 걸러냄
        boolean isGet = "GET".equalsIgnoreCase(request.getMethod());
        String accept = request.getHeader("Accept");
        boolean expectsHtml = accept != null && accept.contains("text/html");

        if (!(isGet && expectsHtml)) {
            return true; // GET + 브라우저 접근이 아니면 무시
        }

        HttpSession session = request.getSession();

        AccountVO account = (AccountVO) session.getAttribute("account");
        
        // 로그인 안 했거나 인증이 필요할 때
        if (account == null || "Y".equals(account.getRequiresVerification())) {
            RedirectUtil.saveRedirectUrl(request, session);
            response.sendRedirect(request.getContextPath() + "/account/login");
            return false;
        }
        
        // 일단 계정 상태 서버에있는걸로 갱신좀 해서 그사이 정지먹진않았나 체크해주고
        account = accUtils.refreshAccount(account);

        String errorParam = "accessFail=notOwner";

        try {
            // 쿼리 파라미터 추출
            AccountType type = AccountType.valueOf(request.getParameter("accountType").toUpperCase());

            // 본인 아니라 어드민도 볼수있게할거냐? 체크용
            String allowAdminParam = request.getParameter("allowAdmin");

            // 일단 진짜 본인만 체크하는거
            boolean isEqType = account.getAccountType() == type;
            // 어드민 허용 페이지고 내가 어드민인지 체크
            boolean isAdminAllowed = "true".equalsIgnoreCase(allowAdminParam)
                    && account.getIsAdmin() == "Y";

            if (isEqType || isAdminAllowed) {
                return true;
            }

        } catch (Exception e) {
            errorParam = "accessFail=checkFail";
        }

        // 문제있으면 기존페이지 링크 저장하고 쿼리스트링에 에러붙여서 돌려보내기
        String referer = request.getHeader("Referer");
        String fallback = request.getContextPath() + "/";

        if (referer != null && !referer.contains("/account/login")) {
            response.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + errorParam);
        } else {
            response.sendRedirect(fallback + "?" + errorParam);
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
