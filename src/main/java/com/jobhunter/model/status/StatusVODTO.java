package com.jobhunter.model.status;

import java.time.LocalDateTime;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class StatusVODTO {

	private int statusNo;

	private LocalDateTime statusDate;

	private int new_Users;
	private int new_Companies;
	private int new_RecruitmentNoticeCnt;
	private int new_Registration;
	private int new_ReviewBoard;

}
