package com.jobhunter.model.company;

import java.sql.Timestamp;

import com.jobhunter.model.customenum.AccountType;

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
public class CompanyVO {

    private Integer uid;
    private String companyName;
    private String companyId;
    private String password;
    private String businessNum;
    private String representative;
    private String email;
    private String mobile;
    private String addr;

    private AccountType accountType = AccountType.COMPANY;

    private Timestamp regDate;
    private String autoLogin;
    private String requiresVerification; // 'Y' or 'N'

    private Timestamp blockDeadline;
    private Timestamp deleteDeadline;
    private String blockReason;

    private Integer loginCnt;
    private Timestamp lastLoginDate;

    private String introduce;
    private String scale;
    private String homePage;
}