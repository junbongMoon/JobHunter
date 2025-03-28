package com.jobhunter.interceptor;

import java.time.Instant;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.service.account.AccountService;
import com.jobhunter.util.AccountUtil;

import lombok.RequiredArgsConstructor;

@Component
public class AccountStatInterceptor implements HandlerInterceptor {

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

        // 일단 계정 상태 서버에있는걸로 갱신좀 해서 그사이 정지먹진않았나 체크해주고
        AccountVO account = accUtils.refreshAccount((AccountVO) session.getAttribute("account"));

        String checkStatType = request.getParameter("checkStatType");

        // 유연성 추가용 쿼리스트링(계정정지/계정삭제 단일체크) 확인
        boolean checkBlock = checkStatType == null || "BLOCK".equalsIgnoreCase(checkStatType);
        boolean checkDelete = checkStatType == null || "DELETE".equalsIgnoreCase(checkStatType);

        // 상태 확인
        boolean isBlocked = account.getBlockDeadline() != null &&
                account.getBlockDeadline().toInstant().isAfter(Instant.now());
        boolean isDeleted = account.getDeleteDeadline() != null;

        // 문제 사유 저장할곳
        String reason = null;

        if (checkStatType == null) { // 둘다 체크할거냐(기본)
            if (isBlocked) { // 사유 저장하기
                reason = "blocked"; // 삭제 대기보단 정지상태 우선 알림
            } else if (isDeleted) {
                reason = "deleted"; // 사실 그냥 실패!같은것만 띄워도 상관없긴한데 기왕 쿼리 붙이는김에 넣는거라
            }
        } else if ("BLOCK".equalsIgnoreCase(checkStatType) && isBlocked) { // 쿼리로 붙인게 있으면 그것만 체크
            reason = "blocked";
        } else if ("DELETE".equalsIgnoreCase(checkStatType) && isDeleted) {
            reason = "deleted";
        }

        if (reason == null) {
            return true; // 문제없으면 통과
        }

        // 문제있으면 기존페이지 링크 저장하고 쿼리스트링에 에러붙여서 돌려보내기
        String referer = request.getHeader("Referer");
        String fallback = request.getContextPath() + "/";
        String errorParam = "error=account_" + reason;

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
