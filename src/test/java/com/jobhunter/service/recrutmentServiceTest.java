package com.jobhunter.service;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.model.recruitmentnotice.RecruitmentWithResume;
import com.jobhunter.model.recruitmentnotice.RecruitmentWithResumePageDTO;
import com.jobhunter.model.recruitmentnotice.TenToFivePageVO;
import com.jobhunter.service.recruitmentnotice.RecruitmentNoticeService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class recrutmentServiceTest {

    @Autowired
    private RecruitmentNoticeService recruitmentService;

    @Test
    public void searchRecruitments_basicTest() throws Exception {
        RecruitmentWithResumePageDTO dto = new RecruitmentWithResumePageDTO();
        dto.setUid(1); // 회사 UID (테스트용 공고가 있는 회사)
        dto.setPage(1); // 첫 페이지
        dto.setSortBy("LATEST"); // 최신순 정렬
        dto.setSearchKeyword("테슫"); // 검색어 없음
        dto.setSearchKeywordType("title"); // 제목 + 소제목 기준
        dto.setNoRead(false);
        dto.setNotClosing(false);
        dto.setApplyViaSite(false);

        TenToFivePageVO result = recruitmentService.searchRecruitments(dto);

        System.out.println("▶ 총 공고 수: " + result.getTotalItems());
        System.out.println("▶ 현재 페이지: " + result.getCurrentPage());
        System.out.println("▶ 페이지 리스트: " + result.getPageList());
        System.out.println("▶ 공고 목록:");

        List<RecruitmentWithResume> list = result.getItems();
        for (RecruitmentWithResume r : list) {
            System.out.printf(" - [%d] %s / %s / 신청서 %d건 / 안읽은신청서: %b / 사이트지원: %b\n",
                    r.getUid(), r.getTitle(), r.getManager(),
                    r.getRegistrationCount(), r.isHasUnreadApplications(), r.isApplyViaSite());
        }

        assertNotNull(result);
        assertTrue(result.getItems().size() <= 5);
    }
}
