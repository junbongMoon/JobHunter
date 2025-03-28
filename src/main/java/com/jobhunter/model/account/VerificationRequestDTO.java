package com.jobhunter.model.account;

import com.jobhunter.model.customenum.AccountType;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerificationRequestDTO {
	
	// 이메일/전화 인증 성공했다고 돌아오면 잠금 풀어줄때 필요한거 담아가는 객체
	
    private String type;         // "email" or "mobile"
    private String value;        // 실제 이메일 또는 휴대폰 번호
    private AccountType accountType; // USER or COMPANY
}
