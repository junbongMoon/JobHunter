package com.jobhunter.model.account;

import com.jobhunter.model.customenum.AccountType;

import lombok.Data;

@Data
public class findIdDTO {
	private String targetType;
	private String targetValue;
	private String targetId;
	private AccountType accountType;
	private String businessNum;
}
