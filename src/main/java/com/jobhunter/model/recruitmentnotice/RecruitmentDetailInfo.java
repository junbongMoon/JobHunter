package com.jobhunter.model.recruitmentnotice;

import java.sql.Timestamp;
import java.util.List;

import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;
import com.jobhunter.model.customenum.MilitaryService;
import com.jobhunter.model.region.Region;
import com.jobhunter.model.region.Sigungu;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@ToString
public class RecruitmentDetailInfo {
	// 아직
	private int uid;
	private String title;
	private String workType;
	private String payType;
	private int pay;
	private String period;
	private String personalHistory;
	private MilitaryService militaryService;
	private String detail;
	private String manager;
	private String miniTitle;
	private Timestamp dueDate;
	private String status;
	// 조회수
	private int count;
	// 작성한 회사 uid
	private int refCompany;
	// 작성자
	private String companyName;
	
	
	// 면접 방식 리스트
	private List<Application> application;
	// 우대 조건 리스트
	private List<Advantage> advantage;
	
	private List<RecruitmentnoticeBoardUpfiles> fileList;
	
	private Region region;
	private Sigungu sigungu;
	
	private MajorCategory majorCategory;
	private SubCategory subcategory;
	
	
	
}
