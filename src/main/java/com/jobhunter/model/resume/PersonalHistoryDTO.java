package com.jobhunter.model.resume;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

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
public class PersonalHistoryDTO {
	private int historyNo;
	private String companyName;
	private String position;
	private String jobDescription;
	private String startDate;
	private String endDate;
	private int resumeNo;
}
