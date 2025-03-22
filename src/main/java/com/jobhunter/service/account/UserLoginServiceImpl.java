package com.jobhunter.service.account;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.jobhunter.model.account.LoginDTO;

import lombok.RequiredArgsConstructor;

@Service("userLoginService")
@RequiredArgsConstructor
public class UserLoginServiceImpl implements AccountLoginService {

    @Override
    public String login(LoginDTO dto, HttpSession session) {
        return "redirect:/";
    }
}
