package com.jobhunter.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class RedirectUtil {

    public static void saveRedirectUrl(HttpServletRequest request, HttpSession session) {
        String method = request.getMethod();
        if ("GET".equalsIgnoreCase(method)) {
            String uri = request.getRequestURI();
            String query = request.getQueryString();
            String fullUrl = uri + (query != null ? "?" + query : "");
            
            if (uri != null && !uri.contains("/account/login")) {
                session.setAttribute("redirectUrl", fullUrl);
            }
        } else {
            String referer = request.getHeader("Referer");
            
            if (referer != null && referer.contains("/account/login")) {
                session.setAttribute("redirectUrl", referer);
            }
        }
    }
    
    public static String getFailedRefererUrl(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String referer = request.getHeader("Referer");
        String fallback = request.getContextPath() + "/";

        session.setAttribute("accessFail", "checkFail");

        // referer가 없으면 fallback
        return (referer != null) ? referer : fallback;
    }
    
    public static boolean isApiRequest(HttpServletRequest request) {
	    String requestedWith = request.getHeader("X-Requested-With");
	    String accept = request.getHeader("Accept");
	    String contentType = request.getContentType();

	    // AJAX 요청 또는 명시적으로 JSON을 요청한 경우
	    return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
	        || (accept != null && accept.contains("application/json"))
	        || (contentType != null && contentType.contains("application/json"));
	}
}
