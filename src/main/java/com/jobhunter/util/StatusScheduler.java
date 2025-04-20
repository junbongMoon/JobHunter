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
    @Scheduled(cron = "0 20 0 * * *")
    public void saveEntireStatus() {
    	
    	statusService.runDailyStatistics();
	    }
	
	
}
