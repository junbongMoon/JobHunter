package com.jobhunter.controller.status;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.model.status.StatusVODTO;
import com.jobhunter.model.status.TotalStatusVODTO;
import com.jobhunter.service.status.StatusService;

@RunWith(SpringJUnit4ClassRunner.class) // 아래의 객체가 Junit4 클래스와 함께 동작하도록
@ContextConfiguration( // 설정 파일의 위치 (여기에서는 dataSource객체가 생성된 root-context.xml의 위치)
      locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class StatusControllerTests {
	
	@Autowired
	private StatusService statusService;
	
//	@Test
	public void testSaveDateStatus() {
		statusService.saveDateStatusByToDay();
		
		 TotalStatusVODTO yesterdayTotal = statusService.getTotalStatusUntilYesterday();
	        StatusVODTO todayIncrement = statusService.getTodayIncrement();

	        TotalStatusVODTO todayTotal;

	        if (yesterdayTotal == null) {
	            todayTotal = TotalStatusVODTO.builder()
	            	.statusDate(LocalDate.now().minusDays(1).atStartOfDay())
	                .totalUsers(todayIncrement.getNewUsers())
	                .totalCompanies(todayIncrement.getNewCompanies())
	                .totalRecruitmentNoticeCnt(todayIncrement.getNewRecruitmentNoticeCnt())
	                .totalRegistration(todayIncrement.getNewRegistration())
	                .totalReviewBoard(todayIncrement.getNewReviewBoard())
	                .build();
	        } else {
	            todayTotal = TotalStatusVODTO.builder()
	            	.statusDate(LocalDate.now().minusDays(1).atStartOfDay())
	                .totalUsers(yesterdayTotal.getTotalUsers() + todayIncrement.getNewUsers())
	                .totalCompanies(yesterdayTotal.getTotalCompanies() + todayIncrement.getNewCompanies())
	                .totalRecruitmentNoticeCnt(yesterdayTotal.getTotalRecruitmentNoticeCnt() + todayIncrement.getNewRecruitmentNoticeCnt())
	                .totalRegistration(yesterdayTotal.getTotalRegistration() + todayIncrement.getNewRegistration())
	                .totalReviewBoard(yesterdayTotal.getTotalReviewBoard() + todayIncrement.getNewReviewBoard())
	                .build();
	        }
	        System.out.println("어제 total : " + yesterdayTotal); // 안찍힌다.
	        System.out.println("오늘 증가량 : " + todayIncrement);
	        
	        System.out.println("오늘 증가량 + 어제 total : " +todayTotal);

	        statusService.saveEntireStatus(todayTotal);
	    }
	

}
