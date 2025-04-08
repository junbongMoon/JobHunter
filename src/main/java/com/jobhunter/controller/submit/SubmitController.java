package com.jobhunter.controller.submit;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;
import com.jobhunter.service.resume.ResumeService;
import com.jobhunter.service.submit.SubmitService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/submit")
@RequiredArgsConstructor
public class SubmitController {
	
	// 
	private SubmitService submitService;

		
	// accept.jsp(승인 페이지)로 이동
	@GetMapping("/accept")
	public void showAcceptPage() {
		
		
		
	}
	
	@GetMapping("/passed")
	public String PassedByRegistration() {
		
		
	// 승인 페이지로 다시 되돌아가게 하자.
		return null;
	}
	
	
}
