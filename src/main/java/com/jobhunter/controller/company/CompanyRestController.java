package com.jobhunter.controller.company;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.company.CompanyService;
import com.jobhunter.service.user.UserService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyRestController {
	private final CompanyService service;
	
	@GetMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<CompanyVO> myinfo(@PathVariable("uid") String uid) {
	    System.out.println(uid);
	    CompanyVO companyVO = null;
	    try {
	    	companyVO = service.showCompanyHome(uid);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return ResponseEntity.status(HttpStatus.OK).body(companyVO);
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
	public ResponseEntity<String> changeContact(@RequestBody ContactUpdateDTO dto) {
	    try {
	        String updatedValue = service.updateContact(dto.getUid(), dto.getType(), dto.getValue());
	        return ResponseEntity.ok(updatedValue);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
	                             .body("연락처 변경 중 오류 발생");
	    }
	}
}
