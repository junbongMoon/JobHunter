package com.jobhunter.model.account;

import com.jobhunter.model.customenum.AccountType;

import lombok.Data;

@Data
public class VerificationRequestDTO {
	
	// 이메일/전화 인증 성공했다고 돌아오면 잠금 풀어줄때 필요한거 담아가는 객체
	
    private int uid;
    private AccountType accountType; // USER or COMPANY
}
