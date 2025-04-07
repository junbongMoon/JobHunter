package com.jobhunter.controller.user;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.user.KakaoUserInfo;
import com.jobhunter.service.user.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
	private final UserService service;

	@GetMapping("/mypage")
	public void showMypage() {
		
	}
	
	@GetMapping("/kakao")
	public String forKakao(@RequestParam("code") String code, Model model, HttpServletRequest request, HttpSession session, HttpServletResponse response) {
		// ✨ contextPath 처리
	    String contextPath = request.getContextPath();
	    if (contextPath == null || contextPath.equals("/")) {
	        contextPath = "";
	    }
	    
	    System.out.println("카카오?" + code);

	    String redirectUri = request.getScheme() + "://" +
	                         request.getServerName() +
	                         (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort()) +
	                         contextPath + "/user/kakao";
		
        String accessToken = null;
        KakaoUserInfo userInfo = null;
		try {
			// 1. 인가 코드로 Access Token 요청
			accessToken = service.getKakaoToken(code, redirectUri);
			// 2. Access Token으로 사용자 정보 요청
			userInfo = service.getKakaoInfo(accessToken);
			AccountVO account = service.loginOrRegisterKakao(userInfo);
			if (account != null) {
				session.setAttribute("account", account);
				String keyName = "kakaoAutoLogin";
				Cookie autoLoginCookie = new Cookie(keyName, userInfo.getKakaoId().toString());
				autoLoginCookie.setMaxAge(60 * 60 * 24 * 7); // 7일
				autoLoginCookie.setPath("/");
				response.addCookie(autoLoginCookie);
				
				String redirectUrl = (String) session.getAttribute("redirectUrl");
				session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
				return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
		String referer = request.getHeader("Referer");
         
	    return "redirect:" + (referer != null ? referer : "/");
	}
	
	@GetMapping("/register")
	public void registUser() {
		
	}

}
