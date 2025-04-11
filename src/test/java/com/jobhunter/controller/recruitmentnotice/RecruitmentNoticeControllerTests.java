package com.jobhunter.controller.recruitmentnotice;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.model.customenum.JobForm;
import com.jobhunter.model.customenum.Method;
import com.jobhunter.model.customenum.MilitaryService;
import com.jobhunter.model.recruitmentnotice.AdvantageDTO;
import com.jobhunter.model.recruitmentnotice.ApplicationDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentNoticeDTO;
import com.jobhunter.model.recruitmentnotice.RecruitmentnoticeBoardUpfiles;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

@RunWith(SpringJUnit4ClassRunner.class) // 아래의 객체가 Junit4 클래스와 함께 동작하도록
@ContextConfiguration( // 설정 파일의 위치 (여기에서는 dataSource객체가 생성된 root-context.xml의 위치)
      locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class RecruitmentNoticeControllerTests {
	
	@Autowired
	private RecruitmentNoticeService recService;
	
	
	// insert 테스트
//	@Test
	public void insertRecruitmentNotice() {
		MilitaryService mili = MilitaryService.EXEMPTED;
		
		 LocalDateTime deadlineDateTime = LocalDateTime.of(2025, 3, 31, 00, 00, 00); // 마감기한 (날짜 + 시간)
         Timestamp deadlineTimestamp = Timestamp.valueOf(deadlineDateTime); // java.sql.Timestamp 변환
		
         
        System.out.println(recService); 
        for(int i = 0; i < 2; i++) {
        	
        
		RecruitmentNoticeDTO dto = RecruitmentNoticeDTO.builder()
				.title("test")
				.workType(JobForm.FULL_TIME)
				.payType("DATE")
				.pay(10000)
				.period("08:00~18:00")
				.personalHistory("코리아 임베디드 4년 근무")
				.militaryService(mili)
				.dueDate(deadlineTimestamp)
				.detail("")
				.manager("이성실")
				.miniTitle("제 1차 테스트")
				.regionNo(12)
				.sigunguNo(198)
				.majorcategoryNo(13)
				.subcategoryNo(383)
				.refCompany(1)
				.build();
		
		List<AdvantageDTO> advantageList = new ArrayList<>();
		AdvantageDTO advdto = AdvantageDTO.builder().advantageType("테스트").build();
		advantageList.add(advdto);
		List<ApplicationDTO> applicationList = new ArrayList<>();
		ApplicationDTO apdto = ApplicationDTO.builder()
				.method(Method.ONLINE)
				.build();
		applicationList.add(apdto);
		List<RecruitmentnoticeBoardUpfiles> fileList = new ArrayList<>();
		
		try {
			recService.saveRecruitmentNotice(dto,advantageList, applicationList, fileList);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("🚨 예외 발생: " + e.getMessage());
			e.printStackTrace();
		}
        }
		
	}

}
