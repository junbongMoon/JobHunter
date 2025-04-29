package com.jobhunter.controller.account;

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

import com.jobhunter.customexception.AccountLockException;
import com.jobhunter.customexception.LoginBlockedException;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.UnlockDTO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.account.AccountService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

	private final AccountService accountService;

	@GetMapping("/unlock")
	public void unlock() {}

	// 인터셉터 없이 로그인버튼 눌러서 들어오는곳
	@GetMapping("/login/return")
	public String redirectToLogin(HttpServletRequest request, HttpSession session) {

		String referer = request.getHeader("Referer");
		if (!referer.contains("/account") && !referer.contains("/register")) {
			session.setAttribute("redirectUrl", referer);
		}

		// 로그인버튼 눌러서 들어왔을때 초기상태 유지+로그인데이터 클린
		session.removeAttribute("account");
		session.removeAttribute("unlockDTO");
		return "redirect:/account/login";
	}

	// 로그인 페이지로 이동
	@GetMapping("/login")
	public String showLoginForm(HttpServletRequest request, HttpSession session,
			@RequestParam(value = "redirect", required = false) String redirect) {

		AccountVO account = (AccountVO) session.getAttribute("account");
		UnlockDTO unlock = (UnlockDTO) session.getAttribute("unlockDTO");

		// 1. 로그인 완료 + 인증도 완료된 경우
		if (account != null && !"Y".equals(account.getRequiresVerification())) {
			String redirectUrl = (String) session.getAttribute("redirectUrl");
			session.removeAttribute("redirectUrl");
			return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
		}

		// 2. 로그인은 됐는데 계정이 잠겨있는 경우
		if (account != null && "Y".equals(account.getRequiresVerification())) {
			unlock = new UnlockDTO(account);
			session.setAttribute("unlockDTO", unlock);
		}

		// 3. 계정 잠금 정보가 있을 경우 잠금 화면
		if (unlock != null) {
			return "account/unlock";
		}

		// 4. 아무것도 없으면 로그인 페이지로
		return "account/login";
	}

	// 실제 로그인
	@PostMapping("/login")
	public String login(@ModelAttribute LoginDTO loginDto, HttpSession session, HttpServletResponse response) {

		session.removeAttribute("remainingSeconds");

		// 자동로그인용 세팅
		String sessionId = session.getId();

		try {
			AccountVO account = accountService.loginAccount(loginDto, sessionId);

			session.removeAttribute("remainingSeconds");
			session.setAttribute("account", account);

			if (loginDto.getAutoLogin() != null) { // 자동로그인 쿠키발급
				String keyName = (loginDto.getAccountType() == AccountType.USER) ? "userAutoLogin" : "companyAutoLogin";
				Cookie autoLoginCookie = new Cookie(keyName, sessionId);
				autoLoginCookie.setMaxAge(60 * 60 * 24 * 7); // 7일
				autoLoginCookie.setPath("/");
				response.addCookie(autoLoginCookie);
			}

			String redirectUrl = (String) session.getAttribute("redirectUrl");
			session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
			return "redirect:" + (redirectUrl != null ? redirectUrl : "/");

		} catch (AccountLockException accLock) { // 계정 하나에 로그인시도 많아서 잠김
			session.setAttribute("unlockDTO", accLock.getUnlockDTO());
			return "redirect:/account/unlock";
		} catch (LoginBlockedException blocked) { // 세션 하나에서 로그인시도 많아서 막아둠
			session.setAttribute("remainingSeconds", blocked.getRemainingSeconds());
		} catch (Exception e) { // 아이디나 비번 틀림 혹은 서버문제
			e.printStackTrace();
		}
		// 기존 유저가 체크한 옵션 복구용
		String queryStr = "?error=true&accountType=" + loginDto.getAccountType();

		if (loginDto.isRemember()) {
			queryStr += "&autoLogin=true";
		}

		// 로그인 실패시 다시 로그인페이지 로딩(인증 필요한지 체크용)
		return "redirect:/account/login" + queryStr;
	}

	@GetMapping("/logout")
	public String logout(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		session.invalidate();

		// 자동 로그인 쿠키 제거
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				if ("userAutoLogin".equals(cookie.getName()) || "companyAutoLogin".equals(cookie.getName())
						|| "kakaoAutoLogin".equals(cookie.getName())) {
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
		return "account/searchAccount";
	}

	@GetMapping("/find/password")
	public String findPassword() {
		return "account/searchPassword";
	}

}