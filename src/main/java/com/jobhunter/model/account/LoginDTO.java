package com.jobhunter.model.account;

import com.jobhunter.model.customenum.AccountType;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@ToString
public class LoginDTO {
	// 로그인에 필요한 정보 담아둠
	
    private String id; // 사용자 아이디 (고유값)
    private Long socialId; // 소셜 로그인 사용자 ID
    private String password; // 비밀번호
    private boolean remember; // 자동 로그인 여부
    private String autoLogin; // 자동 로그인 세션
    private AccountType accountType; // (USER: 일반 사용자, COMPANY: 기업)
}
