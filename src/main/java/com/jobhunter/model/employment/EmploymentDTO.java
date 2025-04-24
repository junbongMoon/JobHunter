package com.jobhunter.model.employment;

import com.jobhunter.model.category.SubCategory;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@ToString
@Builder
public class EmploymentDTO {
		
	private String empSeqno;              // 채용 번호
    private String empWantedTitle;        // 공고 제목
    private String empBusiNm;             // 회사 이름
    private String coClcdNm;              // 기관 구분 (ex. 공공기관)
    private String empWantedStdt;         // 시작일
    private String empWantedEndt;         // 마감일
    private String empWantedTypeNm;       // 고용 형태 (ex. 기간제)
    private String regLogImgNm;           // 이미지 URL
    private String empWantedHomepgDetail; // 상세 페이지 URL
}
