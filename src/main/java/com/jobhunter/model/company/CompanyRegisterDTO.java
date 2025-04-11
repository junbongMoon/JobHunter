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
}