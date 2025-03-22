package com.jobhunter.controller.user;

import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.model.user.LoginDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {
	
	private final UserService userService;
	
	
	// 로그인 페이지 표시 (GET 요청)
    @GetMapping("/login")
    public String showLoginForm() {
        return "user/login";
    }
    
    @PostMapping("/login")
    public String login(LoginDTO loginDto, HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        // 로그인 로직 (유저 인증)
    	try {
            Map<String, Object> result = userService.loginUser(loginDto);

            Boolean authNeeded = (Boolean) result.get("auth"); // 인증 필요 여부
            Boolean success = (Boolean) result.get("success");

            // 인증이 필요한 경우
            if (Boolean.TRUE.equals(authNeeded)) {
            	
                //이메일 인증하게 하는 무언가
            	
            }

            // 로그인 성공 시
            if (Boolean.TRUE.equals(success)) {
                UserVO user = (UserVO) result.get("user");
                session.setAttribute("user", user);
                
                // 자동로그인 체크했으면 토큰주기
                if (loginDto.isRemember()) {
                    String sessionId = session.getId();  // 세션 ID를 토큰으로 사용

                    userService.saveAutoLoginToken(user.getUserId(), sessionId);

                    Cookie autoLoginCookie = new Cookie("autoLogin", sessionId);
                    autoLoginCookie.setMaxAge(60 * 60 * 24 * 30); // 30일
                    autoLoginCookie.setPath("/");
                    response.addCookie(autoLoginCookie);
                }


                // 로그인 전에 요청했던 URL로 이동
                String redirectUrl = (String) session.getAttribute("redirectUrl");
                if (redirectUrl != null) {
                    session.removeAttribute("redirectUrl");
                    return "redirect:" + redirectUrl;
                }
                
                //요청한 URL이 없을때? 아마 이런경우는 없을거같긴한데 혹시몰라서
                //?
                return "redirect:/"; // 기본 메인 페이지
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        
    	// 실패 / 예외
        return "redirect:/user/login?error=true";
    }
}
