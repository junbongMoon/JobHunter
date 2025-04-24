package com.jobhunter.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.jobhunter.service.account.AccountScheduleService;

@Component
@EnableScheduling
public class AccountScheduler {
	
	@Autowired
	private AccountScheduleService accountScheduleService;
	
	@Scheduled(cron = "0 0 4 * * *") // 매일 새벽 4시
    public void deleteExpiredUsers() {
        System.out.println("[스케줄러] 삭제 예약 기간 만료된 계정 처리 시작");
        accountScheduleService.deleteAccount();
    }
   
}
