package com.jobhunter.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.jobhunter.service.submit.SubmitService;
import com.jobhunter.service.submit.SubmitServiceImpl;

@Component
public class SubmitScheduler {
	
	/* 이력서 제출에 대한 Service단 */
	@Autowired
	private SubmitService submitService;
	
	/* 공고의 마감기한이 종료되면 해당 공고에 제출된 것들 중 status 값이 WATING인 것들이 
		EXPIRED로 변경하게 끔
	*/
	//
	
	
}
