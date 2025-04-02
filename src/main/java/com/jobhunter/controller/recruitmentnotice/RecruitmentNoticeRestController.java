package com.jobhunter.controller.recruitmentnotice;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/recruitmentnotice/rest")
@RequiredArgsConstructor
public class RecruitmentNoticeRestController {

	private final RecruitmentNoticeService recService;
	private static final Logger logger = LoggerFactory.getLogger(RecruitmentNoticeRestController.class);
	

	

	

	
	
	
	
	// 파일을 받아오는 메서드

	// 내가 작성한 공고 수정하는 메서드

	// 내가 작성한 공고 삭제하는 메서드
	// delete가 아니라 dueDate(마감기한 now()로 설정) update. sql스케쥴러 사용해서 반년 이따 지우자...

	
}
