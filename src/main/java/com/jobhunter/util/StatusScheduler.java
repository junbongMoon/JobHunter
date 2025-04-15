package com.jobhunter.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;
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
    @Scheduled(cron = "0 10 0 * * *")
    public void saveEntireStatus() {
    	
//		statusService.saveDateStatusByToDay();
//		
//		 TotalStatusVODTO yesterdayTotal = statusService.getTotalStatusUntilYesterday();
//	        StatusVODTO todayIncrement = statusService.getTodayIncrement();
//
//	        TotalStatusVODTO todayTotal;
//
//	        if (yesterdayTotal == null) {
//	            todayTotal = TotalStatusVODTO.builder()
//	            	.statusDate(LocalDate.now().minusDays(1).atStartOfDay())
//	                .totalUsers(todayIncrement.getNewUsers())
//	                .totalCompanies(todayIncrement.getNewCompanies())
//	                .totalRecruitmentNoticeCnt(todayIncrement.getNewRecruitmentNoticeCnt())
//	                .totalRegistration(todayIncrement.getNewRegistration())
//	                .totalReviewBoard(todayIncrement.getNewReviewBoard())
//	                .build();
//	        } else {
//	            todayTotal = TotalStatusVODTO.builder()
//	            	.statusDate(LocalDate.now().minusDays(1).atStartOfDay())
//	                .totalUsers(yesterdayTotal.getTotalUsers() + todayIncrement.getNewUsers())
//	                .totalCompanies(yesterdayTotal.getTotalCompanies() + todayIncrement.getNewCompanies())
//	                .totalRecruitmentNoticeCnt(yesterdayTotal.getTotalRecruitmentNoticeCnt() + todayIncrement.getNewRecruitmentNoticeCnt())
//	                .totalRegistration(yesterdayTotal.getTotalRegistration() + todayIncrement.getNewRegistration())
//	                .totalReviewBoard(yesterdayTotal.getTotalReviewBoard() + todayIncrement.getNewReviewBoard())
//	                .build();
//	        }
//	        System.out.println("어제 total : " + yesterdayTotal); // 안찍힌다.
//	        System.out.println("오늘 증가량 : " + todayIncrement);
//	        
//	        System.out.println("오늘 증가량 + 어제 total : " +todayTotal);
//
//	        statusService.saveEntireStatus(todayTotal);
    	statusService.runDailyStatistics();
	    }
	
	
}
