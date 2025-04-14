package com.jobhunter.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.jobhunter.service.status.StatusService;

/**
 * @author 문준봉
 * JobHunter의 통계를 자정마다 구해주는 Scheduler
 */
@Component
public class StatusScheduler {
	
	@Autowired
	private StatusService statusService;
	// StatusService 와야할 자리
	
	
	/**
	 *  @author 문준봉
	 *
	 * <p>
	 * 일일 통계 insert하는 메서드
	 * </p>
	 * 
	 *
	 */
	@Scheduled(cron = "0 0 0 * * *")  // 매일 00:00:00에 실행
	public void saveDateStatus() {

		statusService.saveDateStatusByToDay();
		
	}
	
	@Scheduled(cron = "0 0 0 * * *")  // 매일 00:00:00에 실행
	public void saveEntireStatus() {

		
		// 
		
		// 구해야 할 것 : 오늘 가입한 일반 유저의 수, 오늘 가입한 기업 유저의 수, 오늘 작성 된 공고의 갯수,
		// 오늘 이력서의 제출 수, 오늘 작성된 리뷰글의 갯 수 
		
	}
	
	
}
