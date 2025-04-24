package com.jobhunter.model.reviewboard;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder // 객체를 만들 때 정해진 패턴대로 생성하도록 Builder 패턴을 사용
@Getter
@Setter
@ToString
public class ReviewDetailViewDTO {
	
	private int boardNo; // 게시글번호 
	private String title; // 이력서 제목
	private String userId; // 작성자 아이디
	private String workType; // 근무 형태
	private String payType; // 급여 형태
	private String personalHistory; // 경력 사항
	private String period; // 근무 기간
	private String detail; // 공고 상세 설명
	private String companyName; // 회사명
	private String reviewResult; // 면접 결과
	private String reviewType; // 면접 유형
	private int reviewLevel; // 난이도
	private String content; // 후기 본문
	private Integer likes; // 좋아요 수
	private int views; // 조회수
	
	private boolean closed;
	private int writerUid; // 작성자 UID
	private String typeOtherText; // 기타 상세 유
	
}
