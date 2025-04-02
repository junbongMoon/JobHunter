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
		
	 private String title; 
	    private String userId; 
	    private String payType;
	    private String detail; 
	    private String companyName; 
	    private String reviewResult;
	    private String reviewType;
	    private int reviewLevel;
	    private String content;
	    private int likes;
}
