package com.jobhunter.controller.user;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.customexception.DuplicateEmailException;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
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
		
	    // 카카오 주소 찾기
	    String redirectUri = formatKakaoUri(request);
		
        String accessToken = null;
        KakaoUserInfoDTO userInfo = null;
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
		} catch (DuplicateEmailException d) {
			// 카카오계정은 아닌데 중복되는 이메일 있음
			System.out.println("이메일중복은 어떻게 처리하지...마이페이지에 계정연동넣고...아이디찾기 페이지로 넘기나?");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
		String referer = request.getHeader("Referer");
         
	    return "redirect:" + (referer != null ? referer : "/");
	}
	
	private String formatKakaoUri(HttpServletRequest request) {
		String contextPath = request.getContextPath();
	    if (contextPath == null || contextPath.equals("/")) {
	        contextPath = "";
	    }
	    // 카카오 주소 찾기
	    String redirectUri = request.getScheme() + "://" +
	                         request.getServerName() +
	                         (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort()) +
	                         contextPath + "/user/kakao";
		return redirectUri;
	}
	
	@GetMapping("/register")
	public void registUser() {
		
	}

	@PostMapping("/register")
    public String processRegister(@ModelAttribute UserRegisterDTO dto, HttpServletRequest request, HttpSession session) {
        // 실제 회원가입 처리
        try {
			AccountVO registAccount = service.registUser(dto);
			if (registAccount != null) {
				session.setAttribute("account", registAccount);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

        String redirectUrl = (String) session.getAttribute("redirectUrl");
		session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
		return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
    }
}
