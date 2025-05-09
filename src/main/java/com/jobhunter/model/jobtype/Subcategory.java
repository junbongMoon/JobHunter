package com.jobhunter.model.jobtype;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@ToString
public class Subcategory {
	private int subcategoryNo;
	private int refMajorcategoryNo;
	private String jobName;
}
