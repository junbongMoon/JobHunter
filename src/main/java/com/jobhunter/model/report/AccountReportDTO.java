package com.jobhunter.model.report;

import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.customenum.ReportCategory;
import com.jobhunter.model.customenum.ReportType;

import lombok.Data;

@Data
public class AccountReportDTO {
	private ReportType reportType;
	private Integer reportTargetPK;
	private Integer targetAccountUid;
	private AccountType targetAccountType;
	private Integer reporterAccountUid;
	private AccountType reporterAccountType;
	private ReportCategory reportCategory;
	private String reportMessage;
	private String reportTargetURL;
	
	public void setReportMessage(String reportMessage) {
	    this.reportMessage = (reportMessage == null || reportMessage.trim().isEmpty()) ? null : reportMessage;
	}
	
	public void setReportType() {
		if (this.targetAccountType == AccountType.USER) {			
			this.reportType = ReportType.USER;
		} else if (this.targetAccountType == AccountType.COMPANY) {
			this.reportType = ReportType.COMPANY;
		}
	}
	
	public void setReportTargetPK() {
		this.reportTargetPK = this.targetAccountUid;
	}
	
}