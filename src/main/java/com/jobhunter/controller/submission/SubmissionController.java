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
import lombok.extern.slf4j.Slf4j;

@Slf4j
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
		log.info("이력서 제출 페이지 요청 - 공고 ID: {}, 페이지: {}, 페이지 크기: {}", new Object[] { uid, page, pageSize });

		// 세션에서 사용자 정보 가져오기
		AccountVO account = (AccountVO) session.getAttribute("account");

		// 공고 정보 조회
		try {
			RecruitmentDetailInfo recruitmentNotice = recruitmentNoticeService.getRecruitmentByUid(uid);
			log.info("공고 정보 조회 결과: {}", recruitmentNotice);

			if (recruitmentNotice == null) {
				log.error("공고 정보가 없습니다. uid: {}", uid);
				model.addAttribute("errorMessage", "존재하지 않는 공고입니다.");
				return "resume/resumeSubmission";
			}

			// 모델에 공고 정보 추가
			model.addAttribute("recruitmentNotice", recruitmentNotice);
			log.info("모델에 공고 정보 추가 완료");

			// 사용자의 이력서 목록 조회 (페이징 처리)
			if (account != null) {
				// 전체 이력서 수 조회
				int totalResumes = resumeService.getTotalResumes(account.getUid());
				int totalPages = (int) Math.ceil((double) totalResumes / pageSize);

				// 페이지 범위 검증
				if (page < 1)
					page = 1;
				if (page > totalPages && totalPages > 0)
					page = totalPages;

				// 이력서 목록 조회
				List<ResumeVO> resumeList = resumeService.getResumeList(account.getUid(), page, pageSize);

				// 모델에 페이징 정보 추가
				model.addAttribute("resumeList", resumeList);
				model.addAttribute("currentPage", page);
				model.addAttribute("pageSize", pageSize);
				model.addAttribute("totalPages", totalPages);
				model.addAttribute("totalResumes", totalResumes);

				log.info("사용자의 이력서 목록 조회 완료: {} 개, 페이지: {}/{}", new Object[] { resumeList.size(), page, totalPages });
			}

		} catch (Exception e) {
			log.error("공고 정보 조회 중 오류 발생: {}", e.getMessage(), e);
			model.addAttribute("errorMessage", "공고 정보를 불러오는 중 오류가 발생했습니다.");
		}

		return "resume/resumeSubmission";
	}

	@PostMapping("/submit")
	public ResponseEntity<Map<String, String>> submitResume(@RequestParam("resumeNo") int resumeNo, @RequestParam("recruitmentNo") int recruitmentNo) {
		log.info("이력서 제출 요청 - 이력서 ID: {}, 공고 ID: {}", resumeNo, recruitmentNo);
		
		try {
			resumeService.submitResume(resumeNo, recruitmentNo);
			Map<String, String> response = new HashMap<>();
			response.put("message", "이력서가 성공적으로 제출되었습니다.");
			return ResponseEntity.ok(response);
		} catch (Exception e) {
			log.error("이력서 제출 중 오류 발생: {}", e.getMessage(), e);
			Map<String, String> response = new HashMap<>();
			response.put("message", "이력서 제출 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
}
