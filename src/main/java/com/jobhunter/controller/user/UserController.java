package com.jobhunter.controller.user;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

	@GetMapping("/mypage")
	public void showMypage() {
		
	}
	
	@PostMapping("kakao")
	@ResponseBody
	public Map<String, Object> forKakao() {
	    Map<String, Object> result = new HashMap<>();
	    result.put("message", "카카오에서 요청을 잘 받았습니다!");
	    result.put("status", "success");
	    return result;
	}

}
