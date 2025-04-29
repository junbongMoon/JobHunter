package com.jobhunter.controller.company;

import java.nio.file.AccessDeniedException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Base64;
import java.util.NoSuchElementException;

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
import com.jobhunter.model.company.BusinessRequestDTO;
import com.jobhunter.model.company.CompanyInfoDTO;
import com.jobhunter.model.company.CompanyVO;
import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.etc.ResponseJsonMsg;
import com.jobhunter.model.user.ContactUpdateDTO;
import com.jobhunter.model.user.PasswordDTO;
import com.jobhunter.service.company.CompanyService;
import com.jobhunter.util.AccountUtil;
import com.jobhunter.util.CompressImgUtil;
import com.jobhunter.util.PropertiesTask;

import lombok.RequiredArgsConstructor;

/**
 * 기업회원 관련 rest컨트롤러
 * <p>
 * 기업회원에 관련된 매핑을 담당하는 rest한 않은 컨트롤러
 * </p>
 * 
 * @author 육근우
 */
@RestController
@RequestMapping("/company")
@RequiredArgsConstructor
public class CompanyRestController {
	/** 기업회원 관련 서비스단 */
	private final CompanyService service;

	/** 계정을 DB의 최신정보로 업데이트 해주는 등의 계정관련 편의성 클래스 */
	private final AccountUtil accUtil;

	/**
	 * 기업회원 상세정보 반환
	 * <p>
	 * 기업회원의 uid를 통해 상세한 정보를 반환해주는 컨트롤러
	 * </p>
	 * 
	 * @param uid 기업회원의 uid
	 * @return ResponseEntity<CompanyVO>
	 * 
	 *         <ul>
	 *         <li>성공시 : CompanyVO (기업회원의 상세정보들이 들어있는 VO객체_json으로 반환)</li>
	 *         <li>실패(404) : status=404 반환. uid 혹은 해당하는 계정없음(로그인끊김 등)</li>
	 *         <li>실패(500) : status=500 반환. 서버연결불량 등 기타 오류</li>
	 *         </ul>
	 */
	@GetMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<CompanyVO> myinfo(@PathVariable("uid") String uid, HttpSession ses) {
		try {

			if (uid == null || AccountUtil.checkAuth(AccountUtil.getAccount(ses), uid, AccountType.COMPANY)) {
				throw new NoSuchElementException();
			}

			CompanyVO companyVO = service.showCompanyHome(uid);

			if (companyVO == null) {
				throw new NoSuchElementException();
			}

			return ResponseEntity.status(HttpStatus.OK).body(companyVO);
		} catch (NoSuchElementException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
		}

	}

	/**
	 * 상세정보 수정
	 * <p>
	 * 기업회원의 상세정보를 uid와 CompanyInfoDTO 객체를 통해 수정하는 컨트롤러
	 * </p>
	 * 
	 * @param companyInfo 수정할 기업회원의 상세정보가 담긴 DTO
	 * @param uid         기업회원의 UID
	 * @param session     세션
	 * @return ResponseEntity<ResponseJsonMsg> 간단한 메시지 담긴 응답객체
	 * 
	 *         <ul>
	 *         <li>성공 : 200</li>
	 *         <li>UID없음(로그인 풀림 등) : 404</li>
	 *         <li>서버 오류 : 500</li>
	 *         </ul>
	 */
	@PostMapping(value = "/info/{uid}", produces = "application/json;charset=UTF-8")
	public ResponseEntity<ResponseJsonMsg> updateCompanyInfo(@RequestBody CompanyInfoDTO companyInfo,
			@PathVariable("uid") Integer uid, HttpSession session) {
		try {
			AccountVO vo = AccountUtil.getAccount(session);
			if(uid == null || AccountUtil.checkAuth(vo, uid, AccountType.COMPANY)) {
				throw new NeedAuthException();
			}

			companyInfo.setUid(uid);

			service.updateCompanyInfo(companyInfo);
			return ResponseEntity.ok().body(ResponseJsonMsg.success());
		}	catch (SQLException e) {
		    e.printStackTrace();
		    return ResponseEntity.status(HttpStatus.INSUFFICIENT_STORAGE).body(ResponseJsonMsg.error("cafe24 요금제 제한등으로 인하여 업로드에 실패했습니다."));
		} catch (NoSuchElementException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseJsonMsg.notFound());
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ResponseJsonMsg.error());
		}
	}

	/**
	 * 비밀번호 확인
	 * <p>
	 * uid와 비밀번호를 받아서 현재 계정의 비밀번호가 맞는지 확인하는 컨트롤러
	 * </p>
	 * 
	 * @param dto uid와 비밀번호가 담긴 dto
	 * @return ResponseEntity<Boolean> 비밀번호가 맞으면 true, 틀리면 false 반환
	 * 
	 *         <ul>
	 *         <li>성공 : Boolean 비밀번호 체크 결과 반환</li>
	 *         <li>실패 : 500 기타 서버 오류</li>
	 *         </ul>
	 */
	@PostMapping(value = "/password", consumes = "application/json")
	public ResponseEntity<Boolean> checkPassword(@RequestBody PasswordDTO dto, HttpSession session) {
		boolean isMatch = false;
		try {
			isMatch = service.checkPassword(dto.getUid(), dto.getPassword());
			if(isMatch) {
				session.setAttribute(dto.getWhereFrom(), dto.getUid());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
		return ResponseEntity.ok(isMatch);
	}

	/**
	 * 비밀번호 변경 컨트롤러
	 * <p>
	 * uid와 새로운 비밀번호를 받아서 계정의 비밀번호를 업데이트 해주는 컨트롤러
	 * </p>
	 * 
	 * @param dto uid와 비밀번호가 담긴 dto
	 * @return ResponseEntity<Void>
	 * 
	 *         <ul>
	 *         <li>성공 : 200</li>
	 *         <li>uid와 세션의 uid 다름 : 404</li>
	 *         <li>서버오류 : 500</li>
	 *         </ul>
	 */
	@PatchMapping(value = "/password", consumes = "application/json")
	public ResponseEntity<Void> changePassword(@RequestBody PasswordDTO dto, HttpSession session) {
		try {
			// 1차 인증 완료했던 uid 및 연락처
			int checkedUid = Integer.parseInt(session.getAttribute("chagePwdCompany").toString());
			String checkedMobile = session.getAttribute("changePwdCompanyMobile").toString();
			String checkedEmail = session.getAttribute("changePwdCompanyEmail").toString();
			
			session.removeAttribute("chagePwdCompany");
			session.removeAttribute("changePwdCompanyMobile");
			session.removeAttribute("changePwdCompanyEmail");
			
			if (!AccountUtil.checkAuth(AccountUtil.getAccount(session), dto.getUid(), AccountType.COMPANY)) {
				throw new AccessDeniedException("잘못된 사용자");
			}
			
			dto.setUid(checkedUid);
			if(checkedMobile != null) {
				dto.setContact(checkedMobile);
				dto.setContactType("mobile");
			} else if (checkedEmail != null) {
				dto.setContact(checkedEmail);
				dto.setContactType("email");
			}

			service.updatePassword(dto);
			return ResponseEntity.ok().build();
		} catch (AccessDeniedException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	/**
	 * 연락처 변경
	 * <p>
	 * uid, 바꿀 연락처 종류(전화번호/이메일), 바꿀 값을 받아 계정의 연락처를 업데이트 하는 컨트롤러
	 * </p>
	 * 
	 * @param dto uid, 바꿀 연락처 종류(전화번호/이메일), 바꿀 값이 담긴 DTO
	 * @return ResponseEntity<String> 성공적으로 바뀌었다면 바뀐 값을 다시 반환해 페이지의 정보들을 업데이트하는데 사용
	 * 
	 * <ul>
	 *         <li>성공 : 200</li>
	 *         <li>페이지의 uid와 세션 안맞음 : 404</li>
	 *         <li>실패 : 500</li>
	 * </ul>
	 */
	@PatchMapping(value = "/contact", consumes = "application/json")
	public ResponseEntity<String> changeContact(@RequestBody ContactUpdateDTO dto, HttpSession session) {
		String changeContactCompanyMobile = (String)session.getAttribute("changeContactCompanyMobile");
		String changeContactCompanyEmail = (String)session.getAttribute("changeContactCompanyEmail");
		
		try {
			if (changeContactCompanyMobile != null && changeContactCompanyMobile.equals("0000")) {
				dto.setType("mobile");
			} else if (changeContactCompanyMobile != null) {
				dto.setType("mobile");
				dto.setValue(changeContactCompanyMobile);
			} else if (changeContactCompanyEmail != null) {
				dto.setType("email");
				dto.setValue(changeContactCompanyEmail);
			} else {
				throw new AccessDeniedException("잘못된 사용자");
			}
			
			AccountVO sessionAccount = (AccountVO) session.getAttribute("account");
			
			if (!AccountUtil.checkAuth(sessionAccount, dto.getUid(), AccountType.COMPANY)) {
				throw new AccessDeniedException("잘못된 사용자");
			}

			String updatedValue = service.updateContact(dto);
			accUtil.refreshAccount(sessionAccount);
			return ResponseEntity.ok(updatedValue);
		} catch (AccessDeniedException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		} catch (Exception e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	/**
	 * 사업자 등록번호 진위여부 확인 API
	 * <p>
	 * 10자리의 숫자(사업자 등록번호)와 창업일, 대표자이름을 받아 공공데이터포털의 API를 이용해 진위여부를 반환하는 API
	 * </p>
	 * 
	 * @param dto 사업자 등록번호, 창업일, 대표자이름이 담긴 DTO
	 * @return ResponseEntity<String> 01은 올바른 사업자 등록정보, 02는 올바르지 못한 정보
	 * 
	 *         <ul>
	 *         <li>성공 : 200, "01"반환</li>
	 *         <li>실패 : 200, "02"반환</li>
	 *         <li>서버오류 : 500</li>
	 *         </ul>
	 */
	@PostMapping(value = "/business", consumes = "application/json")
	public ResponseEntity<String> valiedBusiness(@RequestBody BusinessRequestDTO dto) {
		if (dto.getB_no().equals("0000000000")) {
			return ResponseEntity.ok("01");
		}

		try {

			String valid = service.valiedBusiness(dto);

			return ResponseEntity.ok(valid);

		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("사업자 진위 확인 중 오류 발생");
		}
	}

	/**
	 * 기업회원 아이디 중복체크
	 * <p>
	 * 회원가입시 입력한 아이디와 중복되는 아이디가 존재하는지 체크하기위한 컨트롤러
	 * </p>
	 * 
	 * @param companyId 가입하려는 회원이 입력한 아이디
	 * @return ResponseEntity<Boolean> 중복은 false, 중복된 아이디가 없다면 true반환
	 * 
	 * <ul>
	 * 		<li>성공 : 200, true</li>
	 * 		<li>실패 : 200, false</li>
	 * </ul>
	 */
	@GetMapping(value = "/check/id", produces = "application/json;charset=UTF-8")
	public ResponseEntity<Boolean> checkDuplicateId(@RequestParam String companyId, HttpSession session) {

		boolean exists = false;
		try {
			exists = service.isCompanyIdExists(companyId);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ResponseEntity.ok(exists);
	}

	/**
	 * 연락처 변경
	 * <p>
	 * 기업회원의 uid, 바꿀 연락처의 종류(전화번호, 이메일)와 값을 입력받아 연락처를 바꿔주는 컨트롤러 
	 * </p>
	 * 
	 * @param dto
	 * @param session
	 * @return
	 * 
	 * <ul>
	 * 		<li>반환할 데이터 설멍</li>
	 * </ul>
	 */
	@DeleteMapping(value = "/contact", consumes = "application/json")
	public ResponseEntity<HttpStatus> deleteContact(@RequestBody ContactUpdateDTO dto, HttpSession session) {
		try {
			AccountVO sesAcc = AccountUtil.getAccount(session);
			
			if (!AccountUtil.checkAuth(sesAcc, dto.getUid(), AccountType.COMPANY)) {
				throw new Exception();
			}
			
			service.deleteContact(dto);

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
			int checkedUid = Integer.parseInt(session.getAttribute("deleteAccountCompany").toString());

			if (!AccountUtil.checkUid(sessionAccount, uid)) {
				throw new AccessDeniedException("잘못된 사용자");
			} else if(checkedUid != sessionAccount.getUid()) {
				throw new AccessDeniedException("인증 만료");
			}

			Timestamp deadline = service.setDeleteAccount(uid);
			return ResponseEntity.ok().body(ResponseJsonMsg.success(deadline.toString()));
		} catch (AccessDeniedException e) {
			e.printStackTrace();
			return ResponseEntity.status(HttpStatus.NOT_FOUND).body(ResponseJsonMsg.notFound(e.getMessage()));
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
}
