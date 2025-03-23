// ✅ AccountController.java (통합 + 로그인 진입)
package com.jobhunter.controller.account;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.EmailAuth;
import com.jobhunter.model.account.LoginDTO;
import com.jobhunter.model.account.VerificationRequestDTO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.account.AccountService;
import com.jobhunter.util.RedirectUtil;
import com.jobhunter.util.SendMailService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountController {

	private final AccountService accountService;

	// 인터셉터 하나로 헤더 로그인 눌러도 로그인 끝나고 기존페이지 돌아오게 만드려고 넣음
	@GetMapping("/login/return")
	public String redirectToLogin(HttpServletRequest request, HttpSession session,
			@RequestParam(required = false) String redirect) {

		if (redirect != null && session.getAttribute("redirectUrl") == null) {
			session.setAttribute("redirectUrl", redirect);
		} else {
			RedirectUtil.saveRedirectUrl(request, session);
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

		String referer = request.getHeader("Referer");

		if (redirect != null && session.getAttribute("redirectUrl") == null) {
			session.setAttribute("redirectUrl", redirect);
		} else if (referer != null && !referer.matches(".*/account/(login|signup|verify|email-auth).*")
				&& session.getAttribute("redirectUrl") == null) {
			session.setAttribute("redirectUrl", referer);
		}

		// 인증 성공하면 세션 정리
		if (session.getAttribute("account") != null) {
			AccountVO user = (AccountVO) session.getAttribute("account");
			if (!"Y".equals(user.getRequiresVerification())) {
				session.removeAttribute("requiresVerification");
				session.removeAttribute("authTargetMobile");
				session.removeAttribute("authTargetEmail");
			}
		}

		return "account/login";
	}

	// 실제 로그인
	@PostMapping("/login")
	public String login(@ModelAttribute LoginDTO loginDto, HttpSession session) {

		// auth로그인인터셉터에서 쿼리스트링에 requireVerification=true 식으로 인증필요여부 들고옴
		// auth로그인인터셉터에서 이전페이지나 가려던 페이지(get방식만) uri+쿼리 세션에 넣어둠
		Map<String, Object> result = null;
		try {
			result = accountService.loginAccount(loginDto);

			// 맵에서 auth에 인증필요여부, success에 로그인 성공여부, user에 실제 유저 담아옴
			Boolean auth = (Boolean) result.get("auth");
			Boolean success = (Boolean) result.get("success");

			// 이거 일반이나 기업중 하나 나올거같은데?
			// 로그인이랑 권한만 넣어두는 VO 따로 만듬
			AccountVO account = (AccountVO) result.get("account");
			// 그거 꺼내기

			if (Boolean.TRUE.equals(success)) { // 로그인까지 성공했으면 세션에 바인딩
				session.setAttribute("account", account);

				if (Boolean.TRUE.equals(auth)) { // 로그인은 했는데 인증이 필요
					session.setAttribute("authTargetMobile", account.getMobile());
					session.setAttribute("authTargetEmail", account.getEmail());
					session.setAttribute("requiresVerification", true);
					// 인증할 번호 세션에 묶고 인증필요하다고 저장해둔 다음 다시 로그인페이지 로딩
					return "account/login";
				}

				// 진짜진짜 성공했고 인증까지 필요없으면 원래 가려던 페이지로 이동
				String redirectUrl = (String) session.getAttribute("redirectUrl");
				session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
				return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		// 로그인 실패시 세션 청소하고 다시 로그인페이지 로딩(인증 필요한지 체크용)
		session.removeAttribute("requiresVerification");
		session.removeAttribute("authTargetEmail");
		session.removeAttribute("authTargetMobile");
		session.removeAttribute("account");
		return "redirect:/account/login?error=true";
	}

	@PostMapping(value = "/auth", produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> verify(@RequestBody VerificationRequestDTO dto, HttpSession session) {
		String type = dto.getType();
		String value = dto.getValue();
		AccountType accountType = dto.getAccountType();

		try {
			accountService.setRequiresVerificationFalse(type, value, accountType);

			session.removeAttribute("requiresVerification");
			session.removeAttribute("authTargetEmail");
			session.removeAttribute("authTargetMobile");

			String redirectUrl = (String) session.getAttribute("redirectUrl");
			session.removeAttribute("redirectUrl");

			return ResponseEntity.ok(redirectUrl != null ? redirectUrl : "/");
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error");
		}
	}

	// 이메일 코드 인증용(인증 성공했다고 반환하는거, 계정잠금 해제는 /verify)
	@PostMapping(value = "/auth/email/code", produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> verifyCode(@RequestParam String email, @RequestParam String code,
			HttpSession session) {
		EmailAuth emailAuth = (EmailAuth) session.getAttribute("emailCode:" + email);

		if (emailAuth == null) {
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("인증 코드가 존재하지 않거나 만료되었습니다.");
		}

		Timestamp now = new Timestamp(System.currentTimeMillis());
		if (now.after(emailAuth.getExpireAt())) {
			session.removeAttribute("emailCode:" + email);
			return ResponseEntity.status(HttpStatus.GONE).body("인증 코드가 만료되었습니다.");
		}

		if (!emailAuth.getCode().equals(code)) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("인증 코드가 일치하지 않습니다.");
		}

		// 인증 성공
		
		// 세션에 사용자한테도 인증성공했다고 넣어주기
		AccountVO account = (AccountVO) session.getAttribute("account");
		if (account != null) {
		    account.setRequiresVerification("N");
		    session.setAttribute("account", account); // 갱신
		}
		
		// 세션 청소
		session.removeAttribute("emailCode:" + email);
		return ResponseEntity.ok("인증 성공!");
	}

	// 이메일로 코드보내기
	@PostMapping(value = "/auth/email", produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> sendMail(@RequestParam String email, HttpSession session) {
		// 문자인증이 6자리라서 맞추려고 메일도 6자리 코드 보내기

//	    String code = String.valueOf((int)(Math.random() * 900000) + 100000); // 6자리 숫자 (0~899999 + 100000)

		SecureRandom random = new SecureRandom(); // 똑같이 6자리 만드는건데 그냥 랜덤은 보안이 안좋다길래 시큐리티랜덤이라는게 있다그래서 넣어봄
		int codeTmp = 100000 + random.nextInt(900000); // 소숫점 때서 6자리 정수 고정
		String code = String.valueOf(codeTmp); // 문자열이 뷰단이랑 주고받고 비교 편해서 문자열로 변환

		Timestamp expireAt = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5분 후

		try {
			SendMailService mailService = new SendMailService(email, code);
			mailService.send();

			EmailAuth emailAuth = new EmailAuth(code, expireAt);
			session.setAttribute("emailCode:" + email, emailAuth);

			return ResponseEntity.ok("인증 메일을 전송했습니다. (유효시간 5분)");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("메일 전송 실패: " + e.getMessage());
		}
	}

}