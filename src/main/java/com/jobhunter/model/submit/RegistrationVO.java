package com.jobhunter.model.submit;

import java.sql.Date;

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
public class RegistrationVO {
	private int registrationNo;
	private Status status;
	private int recruitmentNoticePk;
	private Date regDate;
	private int resumePk;
}
