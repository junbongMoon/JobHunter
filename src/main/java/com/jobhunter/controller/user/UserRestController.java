package com.jobhunter.controller.user;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;
import com.jobhunter.util.AccountUtil;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserRestController {
	private final UserService service;
	private final AccountUtil accUtil;
	
	@GetMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<UserVO> myinfo(@PathVariable("uid") String uid) {
	    UserVO userVO = null;
	    try {
	        userVO = service.showMypage(uid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    
	    System.out.println("/info_userVO : " + userVO);

	    return ResponseEntity.status(HttpStatus.OK).body(userVO);
	}
	
	@PostMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
    public ResponseEntity<?> updateUserInfo(@RequestBody UserInfoDTO userInfo, @PathVariable("uid") Integer uid, HttpSession session) {
        
		System.out.println("/info_userInfo : " + userInfo);
		
		if (uid == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "잘못된 계정입니다."));
        }

        userInfo.setUid(uid);
        boolean success = false;
		try {
			success = service.updateUserInfo(userInfo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        return ResponseEntity.ok(Map.of("success", success));
    }
	
	@PostMapping(value = "/password", consumes = "application/json")
	public ResponseEntity<Boolean> checkPassword(@RequestBody PasswordDTO dto) {
	    boolean isMatch = false;
		try {
			isMatch = service.checkPassword(dto.getUid(), dto.getPassword());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    return ResponseEntity.ok(isMatch);
	}
	
	@PatchMapping(value = "/password", consumes = "application/json")
	public ResponseEntity<Void> changePassword(@RequestBody PasswordDTO dto) {
	    try {
			service.updatePassword(dto.getUid(), dto.getPassword());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	    return ResponseEntity.ok().build();
	}
	
	@PatchMapping(value = "/contact", consumes = "application/json")
	public ResponseEntity<String> changeContact(@RequestBody ContactUpdateDTO dto, HttpSession session) {
	    try {
	        String updatedValue = service.updateContact(dto.getUid(), dto.getType(), dto.getValue());
	        accUtil.refreshAccount((AccountVO) session.getAttribute("account"));
	        return ResponseEntity.ok(updatedValue);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body("연락처 변경 중 오류 발생");
	    }
	}
	
	
}
