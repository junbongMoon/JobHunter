package com.jobhunter.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.jobhunter.service.submit.SubmitService;
import com.jobhunter.service.submit.SubmitServiceImpl;

/**
 * @author 문준봉
 * 이력서 제출에 관한 스케쥴러
 */
@Component
public class SubmitScheduler {
	
	
	/**
	 * <p> 
	 * 이력서 제출에 대한 Service단
	 * </p>
	 */
	@Autowired
	private SubmitService submitService;
	

	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 공고의 마감기한이 종료되면 해당 공고에 제출된 것들 중 status 값이 WATING인 것들을 
		EXPIRED로 변경하는 메서드
	 * </p>
	 * 
	 *
	 */
	@Scheduled(cron = "0 0 0 * * *")  // 매일 00:00:00에 실행
	public void updateStatusExpiredToSubmit() {
		LocalDate yesterday = LocalDate.now().minusDays(1);
		String yesterdayStr = yesterday.format(DateTimeFormatter.ISO_DATE);

		System.out.println("[SubmitScheduler] 실행됨 - 대상 날짜: " + yesterdayStr);

		int result;
		try {
			result = submitService.expiredToSubmit(yesterdayStr);
			System.out.println("[SubmitScheduler] EXPIRED 처리된 제출 수: " + result);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
	}
	
	
}
