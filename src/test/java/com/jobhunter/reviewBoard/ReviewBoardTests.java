package com.jobhunter.reviewBoard;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;



@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration( 
		locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class ReviewBoardTests {

	@Autowired
	private ReviewBoardDAO reviewBoardDAO;

    @Test
    public void testSelectRecruitmentList() throws Exception {
    	int boardNo = 21;

    	WriteBoardDTO dto = reviewBoardDAO.selectrecruitmentList(boardNo);

    	assertNotNull("조회 결과가 null입니다. boardNo=" + boardNo, dto);
    	if (dto != null) {
    		System.out.println("회사명: " + dto.getCompanyName());
    		System.out.println("공고번호: " + dto.getGonggoUid());
    		System.out.println("작성자 : " + dto.getWriter());
    	}
    }
    
    
    
}
