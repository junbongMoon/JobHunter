package com.jobhunter.controller.company;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.company.CompanyRegisterDTO;
import com.jobhunter.service.company.CompanyService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyController {
	private final CompanyService service;
	
	@GetMapping("/companyInfo")
	public void showMypage() {
		
	}
	
	@GetMapping("/register")
	public void registUser() {
		
	}
	
	@PostMapping("/register")
    public String processRegister(@ModelAttribute CompanyRegisterDTO dto, HttpServletRequest request, HttpSession session) {
        // 실제 회원가입 처리
        try {
			AccountVO registAccount = service.registUser(dto);
			if (registAccount != null) {
				session.setAttribute("account", registAccount);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

        return "redirect:/";
    }
}
