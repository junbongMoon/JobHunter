package com.jobhunter.service.account;

import javax.servlet.http.HttpSession;

import com.jobhunter.model.account.LoginDTO;

public interface AccountLoginService {
    String login(LoginDTO dto, HttpSession session);
}
