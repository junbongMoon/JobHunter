package com.jobhunter.controller.account;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.account.EmailAuth;
import com.jobhunter.model.account.VerificationRequestDTO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.account.AccountService;
import com.jobhunter.util.AccountUtil;
import com.jobhunter.util.SendMailService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/account")
@RequiredArgsConstructor
public class AccountRestController {

	private final AccountService accountService;

	private final AccountUtil accUtils;

	// =================================권한체커========================================

	// resources/js 폴더에 있는 accountStatus.js 파일 보면 설명서 첨부 (상단 주석)
	// Rest방식/Post등 뷰단 반환 안하는 ajax같은거 전용이고 페이지 넘어가는건 인터셉터 (servlet-context.xml 참고)
	// 사용해주세요

	// 본인 여부 확인
	@GetMapping("/owner/{type}/{uid}")
	public ResponseEntity<?> isOwner(@PathVariable String type, @PathVariable int uid, HttpSession session) {
		AccountVO account = accUtils.refreshAccount((AccountVO) session.getAttribute("account"));

		if (account == null)
			return ResponseEntity.ok(false);

		AccountType targetType;
		try {
			targetType = AccountType.valueOf(type.toUpperCase());
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest().body(false);
		}

		boolean isOwner = account.getUid() == uid && account.getAccountType() == targetType;
		return ResponseEntity.ok(isOwner);
	}

	// 계정 타입(기업/일반) 확인
	@GetMapping("/role/{type}")
	public ResponseEntity<?> hasRole(@PathVariable String type, HttpSession session) {

		AccountVO account = accUtils.refreshAccount((AccountVO) session.getAttribute("account"));

		if (account == null) {
			return ResponseEntity.ok(false);
		}

		AccountType required = AccountType.valueOf(type.toUpperCase());

		if (required == AccountType.ADMIN) {
			if (account.getIsAdmin().equals('Y')) {
				return ResponseEntity.ok(true);
			}
		}
		return ResponseEntity.ok(account.getAccountType() == required);
	}

	// 정지 상태인지 확인
	@GetMapping("/blocked")
	public ResponseEntity<?> isNotBlocked(HttpSession session) {
		AccountVO account = accUtils.refreshAccount((AccountVO) session.getAttribute("account"));
		if (account == null)
			return ResponseEntity.ok(false);

		Timestamp deadline = account.getBlockDeadline();
		boolean notBlocked = (deadline == null || deadline.toInstant().isBefore(Instant.now()));
		return ResponseEntity.ok(notBlocked);
	}

	// 삭제 대기 상태인지 확인
	@GetMapping("/deleted")
	public ResponseEntity<?> isNotDeleted(HttpSession session) {
		AccountVO account = accUtils.refreshAccount((AccountVO) session.getAttribute("account"));
		if (account == null)
			return ResponseEntity.ok(false);

		Timestamp deadline = account.getDeleteDeadline();
		boolean notDeleted = (deadline == null);
		return ResponseEntity.ok(notDeleted);
	}

	// =======================여기까지 권한체커===========================

	// 인증 성공하고 계정 잠금 해제해주는 api
	@PostMapping(value = "/auth", produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> verify(@RequestBody VerificationRequestDTO dto, HttpSession session) {

		// type들 통일
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

	// 이메일로 코드보내기
	@PostMapping(value = "/auth/email", produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> sendMail(@RequestBody Map<String, String> emailTmp, HttpSession session) {
		
		String email = emailTmp.get("email");
		Boolean duple = Boolean.parseBoolean(emailTmp.getOrDefault("checkDuplicate", "false"));
		AccountType accountType = AccountType.valueOf(emailTmp.getOrDefault("accountType", "USER"));

		if (duple) {
			try {
				// 중복이면 true반환
				if (accountService.checkDuplicateEmail(email, accountType)) {
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미 가입된 이메일입니다.");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		// 문자인증이 6자리라서 맞추려고 메일도 6자리 코드 보내기
		SecureRandom random = new SecureRandom(); // 똑같이 6자리 만드는건데 그냥 랜덤은 보안이 안좋다길래 시큐리티랜덤이라는게 있다그래서 넣어봄
		int codeTmp = 100000 + random.nextInt(900000); // 소숫점 때서 6자리 정수 고정
		String code = String.valueOf(codeTmp); // 문자열이 뷰단이랑 주고받고 비교 편해서 문자열로 변환

		Timestamp expireAt = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5분 후

		try {
			System.out.println("이메일보내기 : " + email +", 코드 : " + code);
			SendMailService mailService = new SendMailService(email, code);
			mailService.send();

			EmailAuth emailAuth = new EmailAuth(code, expireAt);
			session.setAttribute("emailCode:" + email, emailAuth);

			return ResponseEntity.ok("인증 메일을 전송했습니다. (유효시간 5분)");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("메일 전송 실패: " + e.getMessage());
		}
	}

	// 이메일 코드 인증용(인증 성공했다고 반환하는거, 계정잠금 해제는 /verify)
	@PostMapping(value = "/auth/email/{code}", produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> verifyCode(@PathVariable("code") String code,
			@RequestBody Map<String, String> emailTmp, HttpSession session) {

		String email = emailTmp.get("email");

		EmailAuth emailAuth = (EmailAuth) session.getAttribute("emailCode:" + email);

		System.out.println("이메일 인증하기 : " + emailAuth);
		System.out.println("인증 이메일 : " + email);
		
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

	// 전화번호 중복 확인
	@PostMapping("/check/mobile")
	public ResponseEntity<String> checkDuplicateMobile(@RequestBody Map<String, String> mobileTmp, HttpSession session) {
		// 문자인증이 6자리라서 맞추려고 메일도 6자리 코드 보내기
		String mobile = mobileTmp.get("mobile");
		AccountType accountType = AccountType.valueOf(mobileTmp.getOrDefault("accountType", "USER"));

		try {
			// 중복이면 true반환
			if (accountService.checkDuplicateMobile(mobile, accountType)) {
				return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이미 가입된 전화번호입니다.");
			}
			return ResponseEntity.ok("사용 가능한 전화번호");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("연결이 불안정합니다. 잠시 후 다시 시도해주세요.");
		}
	}

}
