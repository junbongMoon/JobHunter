package com.jobhunter.controller.user;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserRestController {
	private final UserService service;
	
	@GetMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<UserVO> myinfo(@PathVariable("uid") String uid) {
	    System.out.println(uid);
	    UserVO userVO = null;
	    try {
	        userVO = service.showMypage(uid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return ResponseEntity.status(HttpStatus.OK).body(userVO);
	}
}
