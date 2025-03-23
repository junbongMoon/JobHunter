package com.jobhunter.model.account;

import com.jobhunter.model.customenum.AccountType;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VerificationRequestDTO {
    private String type;         // "email" or "mobile"
    private String value;        // 실제 이메일 또는 휴대폰 번호
    private AccountType accountType; // NORMAL or COMPANY
}
