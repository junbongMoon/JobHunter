package com.jobhunter.controller.resume;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


import com.jobhunter.model.resume.MyRegistrationAdviceSearchDTO;
import com.jobhunter.model.resume.RegistrationAdviceVO;
import com.jobhunter.model.resume.ResumeAdviceVO;

import com.jobhunter.model.account.AccountVO;

import com.jobhunter.model.resume.ResumeUpfileDTO;
import com.jobhunter.model.util.TenToFivePageVO;
import com.jobhunter.service.resume.ResumeService;
import com.jobhunter.util.resume.FileProcessForResume;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/resume")
@RequiredArgsConstructor
/**
 * 이력서 관련 REST API 컨트롤러입니다.
 * <p>
 * 이 클래스는 이력서 삭제 기능을 제공합니다.
 * 기업에서 확인 중인 이력서는 삭제할 수 없으며,
 * 삭제 시 이력서에 첨부된 파일도 함께 제거됩니다.
 * </p>
 * 
 * @author 유지원
 */
public class ResumeRestController {
	
	 /** 이력서 관련 서비스 */
	private final ResumeService resumeService;
	/** 이력서 파일 처리 클래스 */
	private final FileProcessForResume fileProcessForResume;
	
	/**
     * 주어진 이력서 번호에 해당하는 이력서를 삭제합니다.
     * <p>
     * 삭제 전, 해당 이력서가 기업에서 확인중인지 확인하며,
     * 확인중일 경우 삭제를 제한합니다. 
     * 이력서에 첨부된 파일이 있다면 서버에서도 함께 삭제됩니다.
     * </p>
     *
     * @param resumeNo 삭제할 이력서 번호 (PathVariable로 전달)
     * @return 이력서 삭제 결과 메시지를 포함한 HTTP 응답 객체
     * 
     * <ul>
     *     <li>성공 시: 200 OK</li>
     *     <li>기업 열람 중일 경우: 403 FORBIDDEN</li>
     *     <li>오류 발생 시: 500 INTERNAL_SERVER_ERROR</li>
     * </ul>
     * @author 유지원
     */
	@DeleteMapping(value = "/delete/{resumeNo}")
	public ResponseEntity<String> deleteResume(@PathVariable int resumeNo) {
		try {
			// 이력서 상태 확인
			if (resumeService.isResumeChecked(resumeNo)) {
				return ResponseEntity.status(HttpStatus.FORBIDDEN)
						.body("기업에서 확인중인 이력서는 삭제할 수 없습니다.");
			}

			// 이력서 첨삭 상태 확인
			if (resumeService.isResumeAdvice(resumeNo)) {
				return ResponseEntity.status(HttpStatus.FORBIDDEN)
						.body("이력서 첨삭 중인 이력서는 삭제할 수 없습니다.");
			}

			// 이력서에 파일이 있다면 파일 또한 서버에서 삭제
			List<ResumeUpfileDTO> upfiles = resumeService.selectResumeUpfile(resumeNo);
			for (ResumeUpfileDTO upfile : upfiles) {
				fileProcessForResume.removeFile(upfile);
			}
			resumeService.deleteResume(resumeNo);
			return ResponseEntity.ok("이력서가 성공적으로 삭제되었습니다.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("이력서 삭제 중 오류가 발생했습니다.");
		}
	}
	

	@PostMapping(value = "/myRegistrationAdvice")
	public TenToFivePageVO<RegistrationAdviceVO> getMyRegistrationAdvice(@RequestBody MyRegistrationAdviceSearchDTO dto, HttpSession session) {
		try {
			
			AccountVO sessionAcc = (AccountVO)session.getAttribute("account");

			if (sessionAcc != null) {
				
				dto.setUid(sessionAcc.getUid());
				
				return resumeService.selectRegistrationAdviceByMentorWithPaging(dto);				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	@PostMapping(value = "/myResumeAdvice/{page}")
	public TenToFivePageVO<ResumeAdviceVO> getMyResumeAdviceByUserUid(@PathVariable("page")int page, HttpSession session) {
		try {
			AccountVO sessionAcc = (AccountVO)session.getAttribute("account");
			return resumeService.selectResumeAdviceByUserUid(sessionAcc.getUid(), page);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 첨삭 승인 처리
	 * <p>
	 * 첨삭 승인 버튼을 눌렀을 때 첨삭 승인 처리를 합니다.
	 * </p>
	 * 
	 * @param resumeNo 첨삭 승인할 이력서의 번호
	 * @param model    View에 전달할 데이터
	 * @param session  사용자 세션
	 * @return 첨삭 승인 결과 메시지를 포함한 HTTP 응답 객체
	 * @author 유지원
	 */
	@GetMapping("/acceptAdvice/{resumeNo}")
	public ResponseEntity<Map<String, String>> acceptAdvice(@PathVariable int resumeNo, Model model, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();

		try {
			// 이력서 첨삭 승인 처리
			resumeService.acceptAdvice(resumeNo, userUid);

			Map<String, String> response = new HashMap<>();
			response.put("message", "첨삭이 승인되었습니다.");
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			Map<String, String> response = new HashMap<>();
			response.put("message", "첨삭 승인 처리 중 오류가 발생했습니다.");
			return ResponseEntity.ok(response);
		}
	}
	
	/**
	 * 첨삭 거절 처리
	 * <p>
	 * 첨삭 거절 버튼을 눌렀을 때 첨삭 거절 처리를 합니다.
	 * 거절을 하면 첨삭 상태가 첨삭 대기에서 첨삭 거절로 변경됩니다.
	 * 포인트 로그에 포인트 차감 내역이 CANCEL로 업데이트 됩니다.
	 * 포인트를 지불한 유저의 포인트를 돌려줍니다.
	 * </p>
	 * 
	 * @param resumeNo 첨삭 거절할 이력서의 번호
	 * @param model    View에 전달할 데이터
	 * @param session  사용자 세션
	 * @return 첨삭 거절 결과 메시지를 포함한 HTTP 응답 객체
	 * @author 유지원
	 */
	@GetMapping("/rejectAdvice/{resumeNo}")
	public ResponseEntity<Map<String, String>> rejectAdvice(@PathVariable int resumeNo, @RequestParam int ownerUid,
			Model model, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();

		Map<String, String> response = new HashMap<>();
		try {
			// 이력서 첨삭 거절 처리
			boolean result = resumeService.rejectAdvice(resumeNo, userUid, ownerUid);
			if (result) {
				response.put("message", "첨삭을 거절하였습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("message", "이미 첨삭 거절을 하였습니다.");
				return ResponseEntity.ok(response);
			}
		} catch (Exception e) {
			response.put("message", "첨삭 거절 처리 중 오류가 발생했습니다.");
			return ResponseEntity.ok(response);
		}
	}
	

}
