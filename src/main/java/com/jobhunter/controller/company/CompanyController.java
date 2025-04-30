package com.jobhunter.controller.company;

import java.util.Objects;

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
			String backdoor = "0000";
			// 실제 인증한 이메일
			String registCompanyEmail = (String) session.getAttribute("registCompanyEmail");
			System.out.println("registCompanyEmail : " + registCompanyEmail);
			// 실제 인증한 전화번호
			String registCompanyMobile = (String) session.getAttribute("registCompanyMobile");
			System.out.println("registCompanyMobile : " + registCompanyMobile);
			
			if(!Objects.equals(dto.getEmail(), registCompanyEmail)) {
				dto.setEmail(null);
			}
			
			if(!Objects.equals(dto.getMobile(), registCompanyMobile) && !Objects.equals(backdoor, registCompanyMobile)) {
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
		
		return "redirect:/?firstLogin=company";
	}
}
