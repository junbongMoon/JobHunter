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
	

	// 이력서 제출 페이지
	@GetMapping("/check")
	public String submitResumeForm() {
		return "resume/resumeSubmission";
	}

}
