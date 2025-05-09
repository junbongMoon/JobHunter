package com.jobhunter.model.resume;

import com.jobhunter.model.customenum.JobForm;

import lombok.Data;

@Data
public class JobFormDTO {
	private Integer jobFormNo;
	private JobForm form;
	private Integer resumeNo;
}
