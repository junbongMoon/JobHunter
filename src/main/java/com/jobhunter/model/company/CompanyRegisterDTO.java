package com.jobhunter.model.company;

import lombok.Data;

@Data
public class CompanyRegisterDTO {
	private int uid;
	private String companyName; // 회사명
    private String companyId; // 아이디
    private String password; // 비밀번호
    private String businessNum; // 사업자등록번호
    private String representative; // 대표자 이름
    private String email;
    private String mobile;
    
    public void setUid(int uid) {
        this.uid = uid;
    }

    public void setCompanyName(String companyName) {
        this.companyName = nullIfEmpty(companyName);
    }

    public void setCompanyId(String companyId) {
        this.companyId = nullIfEmpty(companyId);
    }

    public void setPassword(String password) {
        this.password = nullIfEmpty(password);
    }

    public void setBusinessNum(String businessNum) {
        this.businessNum = nullIfEmpty(businessNum);
    }

    public void setRepresentative(String representative) {
        this.representative = nullIfEmpty(representative);
    }

    public void setEmail(String email) {
        this.email = nullIfEmpty(email);
    }

    public void setMobile(String mobile) {
        this.mobile = nullIfEmpty(mobile);
    }

    private String nullIfEmpty(String str) {
        return (str == null || str.trim().isEmpty()) ? null : str.trim();
    }
}