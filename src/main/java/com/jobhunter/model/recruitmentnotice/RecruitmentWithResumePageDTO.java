package com.jobhunter.model.recruitmentnotice;

import lombok.Data;

@Data
public class RecruitmentWithResumePageDTO {
	// 공고 작성 회사의 고유번호
	private int uid;

	// 읽으려는 페이지 번호 (1부터 시작)
	private int page;

	// 정렬 기준 (최신순, 마감임박순, 신청서 갯수순)
	private String sortBy;

	// 검색어
	private String searchKeyword;

	// 검색어 타입 (title or manager)
	private String searchKeywordType;

	// 필터 조건들
	private boolean isNoRead;
	private boolean isNotClosing;
	private boolean isApplyViaSite;

	// 고정된 페이지 사이즈
	private final int pageSize = 5;

	// offset 계산 (자동)
	public int getOffset() {
		return (page - 1) * pageSize;
	}
}
