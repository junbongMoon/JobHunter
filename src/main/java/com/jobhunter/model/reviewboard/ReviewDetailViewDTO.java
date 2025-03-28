package com.jobhunter.model.reviewboard;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access =AccessLevel.PROTECTED)
@Builder // 객체를 만들 때 정해진 패턴대로 생성하도록 Builder 패턴을 사용
@Getter
@Setter
@ToString
public class ReviewDetailViewDTO {
	
	  private String title;         // 이력서 제목
	    private String userId;        // 유저 ID
	    private String payType;       // 급여 형태
	    private String detail;        // 공고 상세
	    private String companyName;   // 회사명

	    private String reviewResult;  // 후기 결과
	    private String reviewType;    // 후기 유형
	    private String reviewLevel;   // 후기 난이도
	    private String content;       // 후기 내용
	    private int likes;            // 좋아요 수
}
