package com.jobhunter.controller.user;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;
import com.jobhunter.util.RedirectUtil;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

	private final UserService userService;

	// 인터셉터 하나로 헤더 로그인 눌러도 로그인 끝나고 기존페이지 돌아오게 만드려고 넣음
	@GetMapping("/login/return")
	public String redirectToLogin(HttpServletRequest request, HttpSession session,
			@RequestParam(required = false) String redirect) {

		if (redirect != null && session.getAttribute("redirectUrl") == null) {
			session.setAttribute("redirectUrl", redirect);
		} else {
			RedirectUtil.saveRedirectUrl(request, session);
		}

		return "redirect:/user/login";
	}

	@GetMapping("/login")
	public String showLoginForm(HttpSession session,
			@RequestParam(value = "redirect", required = false) String redirect) {
		if (redirect != null && session.getAttribute("redirectUrl") == null) {
			session.setAttribute("redirectUrl", redirect);
		}
		return "user/login";
	}

	@PostMapping("/login")
	public String login(LoginDTO loginDto, HttpSession session) { // 아이디 비밀번호 소셜아이디(카톡만) 자동로그인 할지 같은거 가져옴
		// auth로그인인터셉터에서 쿼리스트링에 requireVerification=true 식으로 인증필요여부 들고옴
		// auth로그인인터셉터에서 이전페이지나 가려던 페이지(get방식만) uri+쿼리 세션에 넣어둠

		try {

			Map<String, Object> result = userService.loginUser(loginDto);

			// 맵에서 auth에 인증필요여부, success에 로그인 성공여부, user에 실제 유저 담아옴
			Boolean auth = (Boolean) result.get("auth");
			Boolean success = (Boolean) result.get("success");
			UserVO user = (UserVO) result.get("user");
			// 그거 꺼내기

			System.out.println("UserController_login auth" + " : " + auth);
			System.out.println("UserController_login success" + " : " + success);
			System.out.println("UserController_login user" + " : " + user);

			if (Boolean.TRUE.equals(success)) { // 로그인까지 성공했으면 세션에 바인딩
				session.setAttribute("user", user);

				if (Boolean.TRUE.equals(auth)) { // 로그인은 했는데 인증이 필요
					session.setAttribute("authTargetMobile", user.getMobile());
					session.setAttribute("authTargetEmail", user.getEmail());
					session.setAttribute("requiresVerification", true);
					// 인증할 번호 세션에 묶고 인증필요하다고 저장해둔 다음 다시 로그인페이지 로딩
					return "user/login";
				}

				// 진짜진짜 성공했고 인증까지 필요없으면 원래 가려던 페이지로 이동
				String redirectUrl = (String) session.getAttribute("redirectUrl");
				session.removeAttribute("redirectUrl"); // 썼으면 깨끗하게
				return "redirect:" + (redirectUrl != null ? redirectUrl : "/");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/user/login?error=true";
	}

	@PostMapping("/phone-verified")
	@ResponseBody
	public ResponseEntity<String> phoneVerified(@RequestBody Map<String, String> payload, HttpSession session) {
	    String phone = payload.get("phone");
	    return processVerification("mobile", phone, session);
	}

	@PostMapping("/email-verified")
	@ResponseBody
	public ResponseEntity<String> emailVerified(@RequestBody Map<String, String> payload, HttpSession session) {
	    String email = payload.get("email");
	    return processVerification("email", email, session);
	}

	
	private ResponseEntity<String> processVerification(String type, String value, HttpSession session) {
	    try {
	        userService.setRequiresVerificationFalse(type, value);
	        session.removeAttribute("requiresVerification");

	        String redirectUrl = (String) session.getAttribute("redirectUrl");
	        session.removeAttribute("redirectUrl");

	        return ResponseEntity.ok(redirectUrl != null ? redirectUrl : "/");
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("error");
	    }
	}

}
