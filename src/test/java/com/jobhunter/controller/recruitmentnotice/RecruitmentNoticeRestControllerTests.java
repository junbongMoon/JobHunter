package com.jobhunter.controller.recruitmentnotice;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.model.customenum.MilitaryService;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

@RunWith(SpringJUnit4ClassRunner.class) // 아래의 객체가 Junit4 클래스와 함께 동작하도록
@ContextConfiguration( // 설정 파일의 위치 (여기에서는 dataSource객체가 생성된 root-context.xml의 위치)
      locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class RecruitmentNoticeRestControllerTests {
	
	@Autowired
	private RecruitmentNoticeService recService;
	
	
	// insert 테스트
	@Test
	public void insertRecruitmentNotice() {
		MilitaryService mili = MilitaryService.SERVED;
		
		 LocalDateTime deadlineDateTime = LocalDateTime.of(2025, 3, 31, 23, 59, 59); // 마감기한 (날짜 + 시간)
         Timestamp deadlineTimestamp = Timestamp.valueOf(deadlineDateTime); // java.sql.Timestamp 변환
		
         
        System.out.println(recService); 
         
		RecruitmentNoticeDTO dto = RecruitmentNoticeDTO.builder()
				.title("test")
				.workType("")
				.payType("시급")
				.pay(10000)
				.period("08:00~18:00")
				.personalHistory("코리아 임베디드 4년 근무")
				.militaryService(mili)
				.dueDate(deadlineTimestamp)
				.detail("열심히 하겠습니다.")
				.manager("이성실")
				.miniTitle("제 1차 테스트")
				.refCompany(1)
				.build();
		
		
		
		try {
			recService.saveRecruitmentNotice(dto);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("🚨 예외 발생: " + e.getMessage());
			e.printStackTrace();
		}
		
	}

}
