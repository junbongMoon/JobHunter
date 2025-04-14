package com.jobhunter.util;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.jobhunter.model.status.StatusVODTO;
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
		// 어제 올라온 총 합계 테이블 select해서 오늘 올라온 것들을 더해서 insert
		
		// 1. 전날까지의 누적 합계 select
		StatusVODTO yesterdayTotal = statusService.getTotalStatusUntilYesterday();
		// 이거 StatusVODTO 아님 바꿔야댐
		

		// 2. 오늘 하루 증가량 select
//		StatusVODTO todayIncrement = statusService.getTodayIncrement();

		// 3. 두 값을 합쳐서 새로운 누적값 생성
//		StatusVODTO todayTotal = yesterdayTotal.plus(todayIncrement);

		// 4. DB에 insert
//		statusService.insertTodayTotal(todayTotal);

		
	}
	
	
}
