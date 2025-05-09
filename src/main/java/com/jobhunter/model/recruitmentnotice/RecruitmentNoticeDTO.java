package com.jobhunter.model.recruitmentnotice;

import java.sql.Timestamp;
import java.util.List;

import com.jobhunter.model.customenum.JobForm;
import com.jobhunter.model.customenum.MilitaryServe;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@ToString
@Builder
public class RecruitmentNoticeDTO {
	// uid
	private int uid;
	// 공고 제목
	private String title;
	// 근무 형태 (정규, 비정규, 프리랜서 등)
	private JobForm workType;
	// 급여 타입(enum으로 할지 생각 중..)
	private String payType;
	// 급여 액수
	private int pay;
	// 근무 기간 (tt:mm~tt:mm 형태로 받을 계획.. split 써보자잇)
	private String period;
	// 경력
	private String personalHistory;
	// 병역 사항('NOT_SERVED', 'SERVED', 'EXEMPTED' : 미필, 군필, 면제)
	private MilitaryServe militaryService;
	// 공고 상세 내용
	private String detail;
	// 담당자 이름(굳이 company의 userName이 아니어도 됨)
	private String manager;
	// 공고 임시 저장용 소제목
	private String miniTitle;
	// 마감 기한 (String으로 받고 변환 시키자. "2025-03-31"의 형태로 받고 split을 쓰자)
	private String dueDateForString;
	// 마감 기한
	private Timestamp dueDate;
	// 임시저장한 상태 값, 'Y', 'N'으로 받게 해서 'N'일 경우 등록 불가로 해놓자..
	private String status;
	// 작성한 회사의 pk를 참조하는 값
	private int refCompany;
	// 도시
	private int regionNo;
	// 시군구
	private int sigunguNo;
	// 산업군
	private int majorcategoryNo;
	// 직업
	private int subcategoryNo;

	private List<RecruitmentnoticeBoardUpfiles> fileList;
	
}
