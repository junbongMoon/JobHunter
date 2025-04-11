package com.jobhunter.model.recruitmentnotice;

import java.sql.Timestamp;

import com.jobhunter.model.customenum.JobForm;
import com.jobhunter.model.customenum.MilitaryService;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

// 일단 Setter와 builder는 만들어 놓지 않는다.
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@ToString
public class RecruitmentNotice {
	private int uid;
	private String title;
	private JobForm workType;
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
	private Timestamp regDate;
	private int refCompany;
}
