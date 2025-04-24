package com.jobhunter.model.recruitmentnotice;

import java.sql.Timestamp;
import java.util.List;

import com.jobhunter.model.category.MajorCategory;
import com.jobhunter.model.category.SubCategory;
import com.jobhunter.model.customenum.JobForm;
import com.jobhunter.model.customenum.MilitaryServe;
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
	
	/**
	 * <p> 
	 * 고유값
	 * </p>
	 */
	private int uid;
	/**
	 * <p> 
	 * 제목
	 * </p>
	 */
	private String title;
	/**
	 * <p> 
	 * 근무타입
	 * </p>
	 */
	private JobForm workType;
	/**
	 * <p> 
	 * 급여타입
	 * </p>
	 */
	private String payType;
	/**
	 * <p> 
	 * 급여액수
	 * </p>
	 */
	private int pay;
	/**
	 * <p> 
	 * 근무시간
	 * </p>
	 */
	private String period;
	/**
	 * <p> 
	 * 경력사항
	 * </p>
	 */
	private String personalHistory;
	/**
	 * <p> 
	 * 병역사항
	 * </p>
	 */
	private MilitaryServe militaryService;
	/**
	 * <p> 
	 * 상세정보
	 * </p>
	 */
	private String detail;
	/**
	 * <p> 
	 * 매니저 이름
	 * </p>
	 */
	private String manager;
	/**
	 * <p> 
	 * 소제목
	 * </p>
	 */
	private String miniTitle;
	/**
	 * <p> 
	 * 마감기한
	 * </p>
	 */
	private Timestamp dueDate;
	/**
	 * <p> 
	 * 상태
	 * </p>
	 */
	private String status;
	/**
	 * <p> 
	 * 조회수
	 * </p>
	 */
	private int count;
	/**
	 * <p> 
	 * 작성일
	 * </p>
	 */
	private Timestamp regDate;
	
	/**
	 * <p> 
	 * 작성한 회사 uid
	 * </p>
	 */
	private int refCompany;
	 
	/**
	 * <p> 
	 * 작성자 이름
	 * </p>
	 */
	private String companyName;
	
	
	private String companyAddr;
	
	/**
	 * <p> 
	 * 좋아요 수
	 * </p>
	 */
	private int likeCnt;
	
	private RecruitmentStats stats;
	
	
	/**
	 * <p> 
	 * 면접 방식 리스트
	 * </p>
	 */
	private List<Application> application;
	
	/**
	 * <p> 
	 * 우대 조건 리스트
	 * </p>
	 */
	private List<Advantage> advantage;
	
	/**
	 * <p> 
	 * 파일 리스트
	 * </p>
	 */
	private List<RecruitmentnoticeBoardUpfiles> fileList;
	
	/**
	 * <p> 
	 * 도시
	 * </p>
	 */
	private Region region;
	/**
	 * <p> 
	 * 시군구
	 * </p>
	 */
	private Sigungu sigungu;
	
	/**
	 * <p> 
	 * 산업군
	 * </p>
	 */
	private MajorCategory majorCategory;
	/**
	 * <p> 
	 * 직업군
	 * </p>
	 */
	private SubCategory subcategory;
	
	
	
}
