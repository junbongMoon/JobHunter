package com.jobhunter.controller.company;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.service.company.CompanyService;
import com.jobhunter.util.AccountUtil;

import lombok.RequiredArgsConstructor;

/**
 * 기업회원 관련 컨트롤러
 * <p>
 * 기업회원에 관련된 매핑을 담당하는 rest하지 않은 컨트롤러
 * </p>
 * 
 * @author 육근우
 */
@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyController {
	private final CompanyService service;

	@GetMapping("/companyInfo/{uid}")
	public String showCompanyInfo(@PathVariable("uid") int uid, HttpServletRequest request) {
		AccountVO acc = AccountUtil.getAccount(request);
		if (acc.getAccountType() == AccountType.COMPANY && uid == acc.getUid()) {
			System.out.println("본인 정보 페이지");
		}
		return "/company/companyInfo";
	}

	@GetMapping("/register")
	public void registUser() {

	}

	@PostMapping("/register")
	public String processRegister(@ModelAttribute CompanyRegisterDTO dto, HttpServletRequest request,
			HttpSession session) {
		// 실제 회원가입 처리
		try {
			// 실제 인증한 이메일
			String registCompanyEmail = (String) session.getAttribute("registCompanyEmail");
			// 실제 인증한 전화번호
			String registCompanyMobile = (String) session.getAttribute("registCompanyMobile");
			
			if(!dto.getEmail().equals(registCompanyEmail)) {
				dto.setEmail(null);
			}
			
			if(!dto.getMobile().equals(registCompanyMobile) || registCompanyMobile.equals("backdoor")) {
				dto.setMobile(null);
			}

			if (dto.getEmail() != null || dto.getMobile() != null) {
				AccountVO registAccount = service.registCompany(dto);
				if (registAccount != null) {
					session.setAttribute("account", registAccount);
				}
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
		redirectUrl += joinChar + "firstLogin=company";

		return "redirect:" + redirectUrl;
	}
}
