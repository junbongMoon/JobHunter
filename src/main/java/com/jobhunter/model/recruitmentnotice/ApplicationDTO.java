package com.jobhunter.model.recruitmentnotice;

import com.jobhunter.model.customenum.Method;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Setter
@Getter
@ToString
@Builder
public class ApplicationDTO {
	
	private Method method;
	private String detail;
	private int RecruitmentNoticeUid;
}
