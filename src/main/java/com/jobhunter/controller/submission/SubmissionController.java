package com.jobhunter.controller.submission;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.jobhunter.model.recruitmentnotice.RecruitmentDetailInfo;
import com.jobhunter.model.resume.ResumeVO;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.service.resume.ResumeService;

import lombok.RequiredArgsConstructor;


@Controller
@RequestMapping("/submission")
@RequiredArgsConstructor
public class SubmissionController {

	private final ResumeService resumeService;
	private final RecruitmentNoticeService recruitmentNoticeService;

	// 이력서 제출 페이지 (쿼리 파라미터 방식)
	@GetMapping("/check")
	public String submitResumeForm(@RequestParam("uid") int uid,
			@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "pageSize", defaultValue = "5") int pageSize, Model model, HttpSession session) {

		// 세션에서 사용자 정보 가져오기
		AccountVO account = (AccountVO) session.getAttribute("account");

		// 공고 정보 조회
		try {
			RecruitmentDetailInfo recruitmentNotice = recruitmentNoticeService.getRecruitmentByUid(uid);

			if (recruitmentNotice == null) {
				model.addAttribute("errorMessage", "존재하지 않는 공고입니다.");
				return "resume/resumeSubmission";
			}

			// 모델에 공고 정보 추가
			model.addAttribute("recruitmentNotice", recruitmentNotice);

			// 사용자의 이력서 목록 조회 (페이징 처리)
			if (account != null) {
				// 전체 이력서 수 조회
				int totalResumes = resumeService.getTotalResumes(account.getUid(), null);
				int totalPages = (int) Math.ceil((double) totalResumes / pageSize);

				// 페이지 범위 검증
				if (page < 1)
					page = 1;
				if (page > totalPages && totalPages > 0)
					page = totalPages;

				// 이력서 목록 조회
				List<ResumeVO> resumeList = resumeService.getResumeList(account.getUid(), page, pageSize, null);

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
}
