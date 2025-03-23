package com.jobhunter.model.resume;

import java.util.List;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Builder
@Getter
@Setter
@ToString
public class ResumeDTO {
	private int resumeNo;
	private String title;
	private String payType;
	private int pay;
	private String introduce;
	private String saveType;
	private int userUid = 1;
	
	// 고용 형태 리스트
    private List<JobFormDTO> jobForms;

    // 지역 선택 리스트 (region, sigungu)
    private List<Integer> regionNos;   // 시/도 번호
    private List<Integer> sigunguNos;  // 시/군/구 번호

    // 업직종 선택 리스트
    private List<Integer> majorcategoryNos;  // 대분류 번호
    private List<Integer> subcategoryNos;    // 소분류 번호
}
