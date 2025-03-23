package com.jobhunter.controller.recruitmentnotice;

import org.springframework.stereotype.Controller;

import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class RecruitmentNoticeController {
	private final RecruitmentNoticeService recruitmentService;
	
	

}
