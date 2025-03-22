package com.jobhunter.service.account;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.jobhunter.model.account.LoginDTO;

import lombok.RequiredArgsConstructor;

@Service("companyLoginService")
@RequiredArgsConstructor
public class CompanyLoginServiceImpl implements AccountLoginService {

	@Override
	public String login(LoginDTO dto, HttpSession session) {
		// TODO: 기업회원 로그인 로직 구현
		return "redirect:/";
	}
}