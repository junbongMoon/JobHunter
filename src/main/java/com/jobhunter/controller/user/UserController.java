package com.jobhunter.controller.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.User;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
	// 로그인 페이지 표시 (GET 요청)
    @GetMapping("/login")
    public String showLoginForm() {
        return "user/login";
    }
    
    @PostMapping("/login")
    public String login(LoginDTO loginDto, HttpSession session, HttpServletRequest request) {
        // 로그인 로직 (유저 인증)
        User user = null; // 서비스가서 유저 들고오기
        
        if (user != null) {
            session.setAttribute("user", user);

            // 로그인 전에 요청했던 URL로 이동
            String redirectUrl = (String) session.getAttribute("redirectUrl");
            if (redirectUrl != null) {
                session.removeAttribute("redirectUrl");
                return "redirect:" + redirectUrl;
            }
            return "redirect:/"; // 기본 페이지
        }
        return "redirect:/login?error=true";
    }
}
