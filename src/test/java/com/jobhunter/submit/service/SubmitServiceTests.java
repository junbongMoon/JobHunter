package com.jobhunter.submit.service;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.service.submit.SubmitService;

@RunWith(SpringJUnit4ClassRunner.class) // 아래의 객체가 Junit4 클래스와 함께 동작하도록
@ContextConfiguration( // 설정 파일의 위치 (여기에서는 dataSource객체가 생성된 root-context.xml의 위치)
      locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class SubmitServiceTests {
	
	@Autowired
	private SubmitService submitService;
	
	@Test
	public void testExpiredToSubmitBetween() {
		LocalDate today = LocalDate.now();
		LocalDateTime start = today.minusDays(1).atStartOfDay(); // 어제 00:00
		LocalDateTime end = today.atTime(23, 59, 59);            // 오늘 23:59:59
		
		int result = 0;
		try {
			result = submitService.expiredToSubmitBetween(start, end);
			
			System.out.println("변화한 row의 수" + result);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}

}
