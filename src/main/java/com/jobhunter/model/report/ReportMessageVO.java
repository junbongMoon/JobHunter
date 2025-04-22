package com.jobhunter.model.report;

import java.sql.Timestamp;

import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.model.customenum.ReportType;

import lombok.Data;

@Data
public class ReportMessageVO {
    private Integer reportNo;
    private ReportType reportType;
    private Integer targetAccountUid;
    private AccountType targetAccountType;
    private Integer reporterAccountUid;
    private AccountType reporterAccountType;
    private String reportCategory;
    private String reportMessage;
    private String reportTargetURL;
    private String isRead;
    private Timestamp regDate;
} 