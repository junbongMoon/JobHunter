package com.jobhunter.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class RedirectUtil {

    public static void saveRedirectUrl(HttpServletRequest request, HttpSession session) {
        saveRedirectUrl(request, session, "redirectUrl");
    }

    public static void saveRedirectUrl(HttpServletRequest request, HttpSession session, String attributeName) {
        if (session.getAttribute(attributeName) != null) return; // 이미 저장돼 있으면 skip

        String method = request.getMethod();
        if ("GET".equalsIgnoreCase(method)) {
            String uri = request.getRequestURI();
            String query = request.getQueryString();
            String fullUrl = uri + (query != null ? "?" + query : "");
            if (!uri.contains("/user/login")) {
                session.setAttribute(attributeName, fullUrl);
            }
        } else {
            String referer = request.getHeader("Referer");
            if (referer != null && !referer.contains("/user/login")) {
                session.setAttribute(attributeName, referer);
            }
        }
    }
}
