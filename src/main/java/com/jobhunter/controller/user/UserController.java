package com.jobhunter.controller.user;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.user.KakaoUserInfoDTO;
import com.jobhunter.model.user.UserRegisterDTO;
import com.jobhunter.service.user.UserService;
import com.jobhunter.util.AccountUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
	private final UserService service;
	private final AccountUtil accountUtil;

	@GetMapping("/mypage/{uid}")
	public String showMypage(@PathVariable("uid") int uid, HttpServletRequest request) {
		AccountVO acc = AccountUtil.getAccount(request);
		if (acc != null && acc.getAccountType() == AccountType.USER && uid == acc.getUid()) {
			System.out.println("본인 정보 페이지");
		}
		return "/user/mypage";
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
			Map<String, Object> result = service.loginOrRegisterKakao(userInfo);
			
			AccountVO account = (AccountVO) result.get("accountVo");
			Boolean isFirst = (Boolean) result.get("isFirst");
			
			if (account != null) {
				session.setAttribute("account", account);
				
				String keyName = "kakaoAutoLogin";
				Cookie autoLoginCookie = new Cookie(keyName, userInfo.getKakaoId().toString());
				autoLoginCookie.setMaxAge(60 * 60 * 24 * 7); // 7일
				autoLoginCookie.setPath("/");
				response.addCookie(autoLoginCookie);
				
				if (isFirst != null && isFirst) {
					String redirectUrl = (String) session.getAttribute("redirectUrl");
					session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게

					// 기본 경로 설정
					if (redirectUrl == null || redirectUrl.isBlank()) {
					    redirectUrl = "/";
					}

					// 이미 쿼리스트링이 있는 경우 ?가 있으므로 &로 추가, 없으면 ?로 시작
					String joinChar = redirectUrl.contains("?") ? "&" : "?";
					redirectUrl += joinChar + "firstLogin=user";

					return "redirect:" + redirectUrl;
				}
				
				String redirectUrl = (String) session.getAttribute("redirectUrl");
				session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
				return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
			}
		} catch (DataIntegrityViolationException d) {
			// 카카오계정은 아닌데 중복되는 이메일 있음
			return "redirect:/?kakao=emailDuplicate";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
		String referer = request.getHeader("Referer");
         
	    return "redirect:" + (referer != null ? referer : "/");
	}
	
	@GetMapping("/kakao/link")
	public String linkToKakao(@RequestParam("code") String code, Model model, HttpServletRequest request, HttpSession session, HttpServletResponse response) {
		
	    // 카카오 주소 찾기
	    String redirectUri = formatKakaoUri(request) + "/link";
		
        String accessToken = null;
        KakaoUserInfoDTO userInfo = null;
        
        AccountVO account = (AccountVO) session.getAttribute("account");
        
        
        
		try {
			// 1. 인가 코드로 Access Token 요청
			accessToken = service.getKakaoToken(code, redirectUri);
		
			// 2. Access Token으로 사용자 정보 요청
			userInfo = service.getKakaoInfo(accessToken);
			
			userInfo.setUid(account.getUid());
			
			service.linkToKakao(userInfo);
			
			account = accountUtil.refreshAccount(account);
			session.setAttribute("account", account);
			
		} catch (DataIntegrityViolationException e) {
		    // 이메일 중복인 경우 등 제약 조건 위반
			return "redirect:/?kakao=emailDuplicate";
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
         
	    return "redirect:/user/mypage?uid="+ account.getUid() +"&accountType=user";
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

        // 기본 경로 설정
        if (redirectUrl == null || redirectUrl.isBlank()) {
            redirectUrl = "/";
        }

        // 이미 쿼리스트링이 있는 경우 ?가 있으므로 &로 추가, 없으면 ?로 시작
        String joinChar = redirectUrl.contains("?") ? "&" : "?";
        redirectUrl += joinChar + "firstLogin=user";

        return "redirect:" + redirectUrl;
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
}
