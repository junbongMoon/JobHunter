package com.jobhunter.controller.user;

import java.nio.file.AccessDeniedException;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.Collections;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.multipart.MultipartFile;

import com.jobhunter.customexception.NeedAuthException;
import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.etc.ResponseJsonMsg;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.model.user.UserInfoDTO;
import com.jobhunter.model.user.UserVO;
import com.jobhunter.service.user.UserService;
import com.jobhunter.util.AccountUtil;
import com.jobhunter.util.CompressImgUtil;
import com.jobhunter.util.PropertiesTask;

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

		return ResponseEntity.status(HttpStatus.OK).body(userVO);
	}

	@PostMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<?> updateUserInfo(@RequestBody UserInfoDTO userInfoDTO, @PathVariable("uid") Integer uid,
			HttpSession session) {
		try {
			
			if (uid == null) { throw new NeedAuthException();}

			userInfoDTO.setUid(uid);

			service.updateUserInfo(userInfoDTO);
			return ResponseEntity.ok(Collections.singletonMap("result", "success"));

		} catch (NeedAuthException n) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
					.body(Collections.singletonMap("result", "잘못된 요청입니다."));
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.BAD_GATEWAY)
					.body(Collections.singletonMap("result", "연결 상태가 불안정합니다."));
		}
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
			System.out.println(dto);
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
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("연락처 변경 중 오류 발생");
		}
	}

	@GetMapping(value = "/check/id", produces = "application/json;charset=UTF-8")
	public ResponseEntity<Boolean> checkDuplicateId(@RequestParam String userId) {
		boolean exists = false;
		try {
			exists = service.isUserIdExists(userId);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ResponseEntity.ok(exists);
	}
	
	@DeleteMapping(value = "/contact", consumes = "application/json")
	public ResponseEntity<HttpStatus> deleteContact(@RequestBody ContactUpdateDTO dto, HttpSession session) {
		try {
			service.deleteContact(dto.getUid(), dto.getType());
			
			accUtil.refreshAccount((AccountVO) session.getAttribute("account"));
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	@DeleteMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<ResponseJsonMsg> deleteAccount(@PathVariable("uid") Integer uid, HttpSession session) {
		try {

			AccountVO sessionAccount = (AccountVO) session.getAttribute("account");

			if (!AccountUtil.checkUid(sessionAccount, uid)) {
				throw new AccessDeniedException("잘못된 사용자");
			}

			Timestamp deadline = service.setDeleteAccount(uid);
			return ResponseEntity.ok().body(ResponseJsonMsg.success(deadline.toString()));
		} catch (AccessDeniedException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseJsonMsg.notFound());
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ResponseJsonMsg.error());
		}
	}
	
	@DeleteMapping(value = "/info/{uid}/cancelDelete", produces = "application/json;charset=UTF-8")
	public ResponseEntity<Void> deleteCancelAccount(@PathVariable("uid") Integer uid, HttpSession session) {
		try {

			AccountVO sessionAccount = (AccountVO) session.getAttribute("account");

			if (!AccountUtil.checkUid(sessionAccount, uid)) {
				throw new AccessDeniedException("잘못된 사용자");
			}

			service.cancelDeleteAccount(uid);
			return ResponseEntity.ok().build();
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.badRequest().build();
		}
	}
	
	private final CompressImgUtil compressImgUtil;
	@PostMapping("/profileImg")
    public ResponseEntity<String> uploadProfileImg(@RequestParam("file") MultipartFile file,
                                                   @SessionAttribute("account") AccountVO account) {
        try {
            // 압축 (300KB 제한)
        	byte[] compressedImg = compressImgUtil.compressToJpg(file, 300 * 1024);

            // Base64 인코딩
            String base64 = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(compressedImg);

            // DB 저장
            service.updateProfileImg(account.getUid(), base64);

            // 클라이언트에 전달
            return ResponseEntity.ok(base64);

        } catch (Exception e) {
			// TODO Auto-generated catch block
        	e.printStackTrace();
        	return ResponseEntity.status(500).body("이미지 처리 중 오류 발생");
		}
    }
	
	@DeleteMapping("/profileImg")
    public ResponseEntity<String> deleteProfileImg(@SessionAttribute("account") AccountVO account) {
        try {
            // DB 저장
            service.deleteProfileImg(account.getUid());

            // 클라이언트에 전달
            return ResponseEntity.ok(PropertiesTask.getPropertiesValue("config/profileImg.properties", "defaltImg"));

        } catch (Exception e) {
			// TODO Auto-generated catch block
        	e.printStackTrace();
        	return ResponseEntity.status(500).body("이미지 처리 중 오류 발생");
		}
    }
	
	@PatchMapping(value = "/name", consumes = "application/json")
	public ResponseEntity<ResponseJsonMsg> updateUserName(@RequestBody Map<String, String> payload,
	                                        @SessionAttribute("account") AccountVO account,
	                                        HttpSession session) {
	    try {
	        String newName = payload.get("name");
	        
	        System.out.println(newName);
	        if (newName == null || newName.trim().isEmpty()) {
	        	return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseJsonMsg.notFound());
	        }

	        // 서비스 호출
	        service.updateName(account.getUid(), newName.trim());

	        // 세션 정보 갱신
	        account.setAccountName(newName.trim());
	        session.setAttribute("account", account);

	        // 응답
	        return ResponseEntity.ok().body(ResponseJsonMsg.success(newName.trim()));
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ResponseJsonMsg.error());
	    }
	}

}
