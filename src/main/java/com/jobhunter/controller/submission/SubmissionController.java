package com.jobhunter.controller.submission;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
	public String submitResumeForm(@RequestParam int uid, Model model, HttpSession session) {
		log.info("이력서 제출 페이지 요청 - 공고 ID: {}", uid);
		
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
			
		} catch (Exception e) {
			log.error("공고 정보 조회 중 오류 발생: {}", e.getMessage(), e);
			model.addAttribute("errorMessage", "공고 정보를 불러오는 중 오류가 발생했습니다.");
		}
		
		return "resume/resumeSubmission";
	}
	
	// 이전에 구현한 경로 변수 방식의 메서드도 유지 (선택적)
	@GetMapping("/{uid}")
	public String submitResumeFormWithPathVariable(@PathVariable int uid, Model model, HttpSession session) {
		log.info("이력서 제출 페이지 요청 (경로 변수) - 공고 ID: {}", uid);
		return submitResumeForm(uid, model, session);
	}

}
