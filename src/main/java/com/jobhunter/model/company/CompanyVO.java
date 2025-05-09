package com.jobhunter.model.company;

import java.io.IOException;
import java.sql.Timestamp;

import com.jobhunter.model.customenum.AccountType;
import com.jobhunter.util.PropertiesTask;

import lombok.Data;

@Data
public class CompanyVO {

    private Integer uid;
    private String companyName;
    private String companyId;
    private String businessNum; // 사업자번호
    private String representative; // 대표자명
    private String email;
    private String mobile;
    private String addr;
    private String detailAddr; // 상세주소

    private AccountType accountType;

    private Timestamp regDate;
    private String autoLogin;
    private String requiresVerification; // 'Y' or 'N'

    private Timestamp blockDeadline;
    private Timestamp deleteDeadline;
    private String blockReason;

    private Integer loginCnt;
    private Timestamp lastLoginDate;

    private String introduce; // 회사소개
    private String scale; // 회사규모
    private String homePage; // 회사 홈페이지
    
    private String companyImg; // 회사 프로필 이미지
    
    public void setCompanyImg(String companyImg) {
    	if (companyImg == null || companyImg.equals("")) {
    		try {
    			String defaltImg = PropertiesTask.getPropertiesValue("config/profileImg.properties", "defaltImg");
				this.companyImg = defaltImg;
			} catch (IOException e) {
				this.companyImg = null;
			}
    	} else {
    		this.companyImg = companyImg;
    	}
	}
}

//private String detailAddr; // 상세주소
//private String userImg; // 유저 이미지
//private String payType; // 희망 급여 유형
//private Integer pay; // 희망 급여 금액
//private String isSocial; // 소셜 로그인 여부 ("Y": 소셜 로그인 사용자, "N": 일반 사용자)
//private MilitaryService militaryService; // 병역 사항 (NOT_COMPLETED: 미필, COMPLETED: 군필, EXEMPTED: 면제)
//private Nationality nationality; // 국적 (KOREAN: 한국인, FOREIGNER: 외국인)
//private String disability; // 장애 여부