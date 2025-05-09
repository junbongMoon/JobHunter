package com.jobhunter.reviewBoard;


import static org.junit.Assert.assertNotNull;

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
import com.jobhunter.service.reviewboard.ReviewBoardService;
import junit.framework.Assert;


@RunWith(SpringJUnit4ClassRunner.class) 
@ContextConfiguration( 
		locations = { "file:src/main/webapp/WEB-INF/spring/**/root-context.xml" })
public class ReviewBoardTests {

	@Autowired
	private ReviewBoardDAO reviewBoardDAO;
	
	@Autowired
	private ReviewBoardService service;
	
    

    //@Test
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
    
    
    @Test
    public void testInsertDummyReviews() throws Exception {
        String[] userId = { "tester123","gosue125" };
        String[] reviewTypes = { "FACE_TO_FACE", "VIDEO", "PHONE", "OTHER" };

        for (int i = 0; i < 30; i++) {
            int randomWriterIndex = (int) (Math.random() * userId.length);
            int randomTypeIndex = (int) (Math.random() * reviewTypes.length);

            String reviewType = reviewTypes[randomTypeIndex];
            String user = userId[randomWriterIndex];

            WriteBoardDTO dto = WriteBoardDTO.builder()
                .gonggoUid(1)  // 존재하는 공고 UID
                .writer(1)     // userId (외래키니까 실제로 있는 id로 설정)
                .companyName("랜덤회사 " + (i + 1))
                .reviewType(reviewType)
                .typeOtherText(reviewType.equals("OTHER") ? "기타 유형 상세 " + (i + 1) : null)
                .reviewLevel((i % 5) + 1)
                .reviewResult("PASSED")
                .content("랜덤 후기 내용 " + (i + 1))
                .build();

            boolean result = service.saveReview(dto);

            // 검증 (실제 환경에선 assert만 쓰는게 좋음)
            Assert.assertEquals(true, result);
            System.out.println("Insert 완료: " + dto.getCompanyName());
        }
    
}
}
