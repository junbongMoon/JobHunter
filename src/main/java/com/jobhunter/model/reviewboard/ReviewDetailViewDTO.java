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
	
    private String title;         // 공고 제목
    private String detail;        // 공고 상세내용
    private String companyName;   // 회사 이름
    private String userName;      // 작성자 이름
    private String content;       // 기존 후기 내용 (수정용)
    private int reviewLevel;
}
