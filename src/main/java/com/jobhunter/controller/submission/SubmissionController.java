package com.jobhunter.controller.submission;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.jobhunter.model.account.AccountVO;
import com.jobhunter.model.prboard.PRBoardVO;
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.service.prboard.PRBoardService;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.service.resume.ResumeService;

import lombok.RequiredArgsConstructor;

/**
 * 이력서 제출(지원) 관련 기능을 처리하는 컨트롤러입니다.
 * <p>
 * 공고 상세 페이지에서 이력서를 선택하여 제출할 수 있으며,
 * 이력서 제출 시 중복 제출 여부도 확인합니다.
 * </p>
 * 
 * @author 유지원
 */
@Controller
@RequestMapping("/submission")
@RequiredArgsConstructor
public class SubmissionController {

	private final ResumeService resumeService;
	private final RecruitmentNoticeService recruitmentNoticeService;
	private final PRBoardService prBoardService;

	/**
	 * 이력서 제출 페이지를 출력합니다.
	 * <p>
	 * 해당 채용 공고의 상세 정보를 불러오고, 로그인한 사용자의 이력서 목록을 페이징 처리하여 함께 전달합니다.
	 * </p>
	 *
	 * @param uid 채용 공고 UID
	 * @param page 현재 페이지 번호 (기본값 1)
	 * @param pageSize 페이지당 출력할 이력서 수 (기본값 5)
	 * @param searchTitle 이력서 제목 검색 키워드 (선택)
	 * @param model 뷰에 전달할 데이터
	 * @param session 사용자 세션 (로그인 정보 포함)
	 * @return 이력서 제출 JSP 뷰 경로
	 */
	// 이력서 제출 페이지 (쿼리 파라미터 방식)
	@GetMapping({"/check", "/adCheck"})
	public String submitResumeForm(
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "pageSize", defaultValue = "5") int pageSize,
			@RequestParam(value = "searchTitle", required = false) String searchTitle,
			@RequestParam(value = "boardNo", required = false) int boardNo,
			Model model, HttpSession session, HttpServletRequest request) {

		// 세션에서 사용자 정보 가져오기
		AccountVO account = (AccountVO) session.getAttribute("account");
		String uri = request.getRequestURI();

		
		try {
			// 공고 정보 조회
			if (uri.contains("check")) {
				RecruitmentDetailInfo recruitmentNotice = recruitmentNoticeService.getRecruitmentByUid(boardNo);

				if (recruitmentNotice == null) {
					model.addAttribute("errorMessage", "존재하지 않는 공고입니다.");
					return "resume/resumeSubmission";
				}

				// 모델에 공고 정보 추가
				model.addAttribute("recruitmentNotice", recruitmentNotice);
			} else if (uri.contains("adCheck")) { // 첨삭 PR 페이지에서 접근
				PRBoardVO prBoard = prBoardService.getPRBoardDetail(boardNo);
				// 첨삭 PR 페이지에서 접근 시 모드 설정
				model.addAttribute("mode", "adCheck");
				model.addAttribute("prBoard", prBoard);
			}

			// 사용자의 이력서 목록 조회 (페이징 처리)
			if (account != null) {
				// 전체 이력서 수 조회
				int totalResumes = resumeService.getTotalResumes(account.getUid(), searchTitle);
				int totalPages = (int) Math.ceil((double) totalResumes / pageSize);

				// 페이지 범위 검증
				if (page < 1)
					page = 1;
				if (page > totalPages && totalPages > 0)
					page = totalPages;

				// 이력서 목록 조회
				List<ResumeVO> resumeList = resumeService.getResumeList(account.getUid(), page, pageSize, searchTitle);

				// 모델에 페이징 정보 추가
				model.addAttribute("resumeList", resumeList);
				model.addAttribute("currentPage", page);
				model.addAttribute("pageSize", pageSize);
				model.addAttribute("totalPages", totalPages);
				model.addAttribute("totalResumes", totalResumes);
				
				// 페이지 블록 계산
				int blockSize = 5; // 한 블록당 표시할 페이지 수
				int currentBlock = (int) Math.ceil((double) page / blockSize);
				int startPage = (currentBlock - 1) * blockSize + 1;
				int endPage = Math.min(startPage + blockSize - 1, totalPages);
				
				model.addAttribute("startPage", startPage);
				model.addAttribute("endPage", endPage);
				model.addAttribute("currentBlock", currentBlock);
				model.addAttribute("totalBlocks", (int) Math.ceil((double) totalPages / blockSize));

			}

		} catch (Exception e) {
			model.addAttribute("errorMessage", "공고 정보를 불러오는 중 오류가 발생했습니다.");
		}

		return "resume/resumeSubmission";
	}

	/**
	 * 선택한 이력서를 특정 채용 공고에 제출합니다.
	 * <p>
	 * 제출 전에 사용자가 해당 공고에 이미 지원한 이력이 있는지 확인하며,
	 * 중복 지원일 경우 실패 메시지를 반환합니다.
	 * </p>
	 *
	 * @param resumeNo 제출할 이력서 번호
	 * @param recruitmentNo 채용 공고 번호
	 * @param session 사용자 세션
	 * @return 제출 성공 또는 실패 메시지를 담은 JSON 응답
	 */
	@PostMapping("/submit")
	public ResponseEntity<Map<String, String>> submitResume(@RequestParam("resumeNo") int resumeNo, @RequestParam("recruitmentNo") int recruitmentNo, HttpSession session) {
		AccountVO account = (AccountVO) session.getAttribute("account");
		int userUid = account.getUid();
		try {
			// 이력서 중복 제출 확인
			boolean isAlreadySubmitted = resumeService.isResumeAlreadySubmitted(userUid, recruitmentNo);
			if (!isAlreadySubmitted) {
				// 이력서 제출
				resumeService.submitResume(resumeNo, recruitmentNo);
				Map<String, String> response = new HashMap<>();
				response.put("success", "이력서가 성공적으로 제출되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				// 중복 지원 시 메시지 반환
				Map<String, String> response = new HashMap<>();
				response.put("fail", "해당 공고에는 이력서가 이미 제출되었습니다.");
				return ResponseEntity.ok(response);
			}
		} catch (Exception e) {
			Map<String, String> response = new HashMap<>();
			response.put("error", "이력서 제출 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	/**
	 * 이력서 첨삭 신청을 처리합니다.
	 * <p>
	 * 선택한 이력서를 첨삭자에게 첨삭 신청합니다.
	 * 중복 신청을 방지하기 위해 이미 신청한 이력서인지 확인합니다.
	 * </p>
	 *
	 * @param resumeNo 이력서 번호
	 * @param mentorUid 첨삭자 UID
	 * @return 첨삭 신청 결과
	 */
	@PostMapping("/submitAdvice")
	public ResponseEntity<Map<String, String>> submitAdvice(@RequestParam("resumeNo") int resumeNo, @RequestParam("mentorUid") int mentorUid) {
		try {
			// 이력서 첨삭 신청
			boolean result = resumeService.submitAdvice(mentorUid, resumeNo);
			
			Map<String, String> response = new HashMap<>();
			if (result) {
				response.put("success", "이력서 첨삭 신청이 완료되었습니다.");
				return ResponseEntity.ok(response);
			} else {
				response.put("fail", "이미 첨삭 신청한 이력서입니다.");
				return ResponseEntity.ok(response);
			}
		} catch (Exception e) {
			Map<String, String> response = new HashMap<>();
			response.put("error", "이력서 첨삭 신청 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
}
