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
public class RecruitmentnoticContentDTO {
	private int recruitmentnoticeNo; //공고 넘버 
	private String resumeTitle; // 이력서 제목
	private String recruitmentTitle; // 공고 제목
	private String companyName; // 회사 이름
	private String workType; // 근무 형태
	private String personalHistory; // 경력 사항
	private String payType; // 급여 형태
	private String period; // 근무 기간

}
