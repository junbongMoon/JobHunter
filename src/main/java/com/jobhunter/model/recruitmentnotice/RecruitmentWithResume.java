package com.jobhunter.model.recruitmentnotice;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class RecruitmentWithResume {
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
	 * 해당 공고에 지원한 신청서 수
	 * </p>
	 */
	private int registrationCount;

	/**
	 * <p>
	 * 읽지 않은 신청서가 하나 이상 존재하는지 여부
	 * </p>
	 */
	private boolean hasUnreadApplications;

	/**
	 * <p>
	 * 해당 공고가 사이트 내 자체 지원 방식(온라인 지원)을 사용하는지 여부
	 * </p>
	 */
	private boolean isApplyViaSite;
}
