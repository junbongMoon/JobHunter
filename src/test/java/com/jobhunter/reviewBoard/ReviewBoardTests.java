package com.jobhunter.reviewBoard;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.ui.ModelMap;

import com.jobhunter.controller.reviewboard.ReviewBoardController;
import com.jobhunter.dao.reviewboard.ReviewBoardDAO;
import com.jobhunter.model.reviewboard.ReviewDetailViewDTO;
import com.jobhunter.model.reviewboard.WriteBoardDTO;



@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration( 
		locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class ReviewBoardTests {

	@Autowired
	private ReviewBoardDAO reviewBoardDAO;
	

    @Autowired
    private ReviewBoardController controller;

    
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
    
//    @Test
//    public void testShowReviewDetail() {
//        // given
//        int testBoardNo = 21;
//        String testOtherText = "기타면접 테스트";
//
//        // when
//        ModelMap model = new ModelMap();
//        String viewName = controller.showReviewDetail(testBoardNo, model, null);
//
//        // then
//        Assertio("뷰 이름이 예상과 다릅니다.", "reviewBoard/detail", true);
//
//        ReviewDetailViewDTO detail = (ReviewDetailViewDTO) model.get("detail");
//        assertNotNull("상세 데이터가 null입니다.", detail);
//
//        // 출력 확인
//        System.out.println("조회된 회사명: " + detail.getCompanyName());
//        System.out.println("면접유형: " + detail.getReviewType());
//
//        // FlashAttribute 검증
//        assertEquals("기타 텍스트가 일치하지 않습니다.", testOtherText, model.get("reviewTypeOtherText"));
//    }
    
}
