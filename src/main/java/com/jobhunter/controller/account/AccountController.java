package com.jobhunter.controller.account;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.account.AccountService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

	private final AccountService accountService;
	

	// 인터셉터 없이 로그인버튼 눌러서 들어오는곳
	@GetMapping("/login/return")
	public String redirectToLogin(HttpServletRequest request, HttpSession session) {

		String redirectUrl = (String) session.getAttribute("redirectUrl");
		if (redirectUrl == null) {
			String referer = request.getHeader("Referer");
			if (referer == null) {
				session.setAttribute("redirectUrl", referer);
			}
		}

		// 로그인버튼 눌러서 들어왔을때 초기상태 유지+로그인으로 인증 건너뛰기 막는용 로그인데이터도 클린
		// 어차피 정상적으로 로그인버튼 누르는건 로그인 안된유저뿐이니까
		session.removeAttribute("requiresVerification");
		session.removeAttribute("authTargetEmail");
		session.removeAttribute("authTargetMobile");
		session.removeAttribute("account");

		return "redirect:/account/login";
	}

	// 로그인 페이지로 이동
	@GetMapping("/login")
	public String showLoginForm(HttpServletRequest request, HttpSession session,
			@RequestParam(value = "redirect", required = false) String redirect) {

		System.out.println(session.getAttribute("redirectUrl"));
		// 인증 성공하면 세션 정리
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account != null) {
			if ("Y".equals(account.getRequiresVerification())) {
				session.setAttribute("requiresVerification", true);
			} else { // 자동로그인 또는 로그인 성공하고 인증도 필요없을때
				session.removeAttribute("requiresVerification");
				
				String redirectUrl = (String) session.getAttribute("redirectUrl");
				session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
				return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
			}
		}

		return "account/login";
	}

	// 실제 로그인
	@PostMapping("/login")
	public String login(@ModelAttribute LoginDTO loginDto, HttpSession session, HttpServletResponse response) {

		// 자동로그인용 세팅
		String sessionId = session.getId();
		if (loginDto.getAutoLogin() != null && loginDto.getAutoLogin().equals("on")) {
			loginDto.setAutoLogin(sessionId);
		}
		
		// auth로그인인터셉터에서 쿼리스트링에 requireVerification=true 식으로 인증필요여부 들고옴
		// auth로그인인터셉터에서 이전페이지나 가려던 페이지(get방식만) uri+쿼리 세션에 넣어둠
		Map<String, Object> result = null;
		try {
			result = accountService.loginAccount(loginDto);
			
			if (result.get("remainingSeconds") != null) {
			    int remainingSeconds = (int) result.get("remainingSeconds");
			    if (remainingSeconds >= 0) {
			        session.setAttribute("remainingSeconds", remainingSeconds);
			        return "account/login";
			    }
			}
			session.removeAttribute("remainingSeconds");
			
			// success에 로그인 성공여부, user에 실제 유저 담아옴
			Boolean success = (Boolean) result.get("success");

			// 이거 일반이나 기업중 하나 나올거같은데?
			// 로그인이랑 권한만 넣어두는 VO 따로 만듬
			AccountVO account = (AccountVO) result.get("account");
			// 그거 꺼내기

			if (Boolean.TRUE.equals(success)) { // 로그인까지 성공했으면 세션에 바인딩

				session.setAttribute("account", account);

				if (account.getRequiresVerification().equals("Y")) { // 로그인은 했는데 인증이 필요
					// 다시 로그인페이지 로딩 (로딩하면서 자동 인증 체크)
					session.setAttribute("requiresVerification", true);
					return "account/login";
				}

				// 진짜진짜 성공했고 인증까지 필요없으면 원래 가려던 페이지로 이동

				if (loginDto.getAutoLogin() != null) {

					String keyName = (loginDto.getAccountType() == AccountType.USER) 
							? "userAutoLogin"
							: "companyAutoLogin";
					Cookie autoLoginCookie = new Cookie(keyName, sessionId);
					autoLoginCookie.setMaxAge(60 * 60 * 24 * 7); // 7일
					autoLoginCookie.setPath("/");
					response.addCookie(autoLoginCookie);
				}

				String redirectUrl = (String) session.getAttribute("redirectUrl");
				session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
				return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 로그인 실패시 세션 청소하고 다시 로그인페이지 로딩(인증 필요한지 체크용)
		session.removeAttribute("requiresVerification");
		session.removeAttribute("account");
		return "redirect:/account/login?error=true&accountType=" + loginDto.getAccountType() + "&autoLogin=" + loginDto.getAutoLogin();
	}

	@GetMapping("/logout")
	public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		session.invalidate();
		
		// 자동 로그인 쿠키 제거
	    Cookie[] cookies = request.getCookies();
	    if (cookies != null) {
	        for (Cookie cookie : cookies) {
	            if ("userAutoLogin".equals(cookie.getName()) || "companyAutoLogin".equals(cookie.getName())) {
	                cookie.setValue("");
	                cookie.setMaxAge(0);
	                cookie.setPath("/");
	                response.addCookie(cookie);
	            }
	        }
	    }
	    
		return "redirect:/";
	}

	@GetMapping("/find/id")
	public String findId() {
		System.out.println("미구현");
		return "redirect:/";
	}

	@GetMapping("/find/password")
	public String findPassword() {
		System.out.println("미구현");
		return "redirect:/";
	}
	
	@GetMapping("/test")
	public void testPage() {
	}
	
	@GetMapping("/testLoginAjax")
	public void testLoginPage() {
	}
	
	@GetMapping("/testGetLogin")
	public void testGetLoginPage() {
	}
	
	@GetMapping("/testGetOwner")
	public void testGetOwnerPage() {
	}
	
	@GetMapping("/testGetRole")
	public void testGetRolePage() {
	}
	
	@GetMapping("/testGetBlocked")
	public void testGetBlockedPage() {
	}

}