package com.jobhunter.model.account;

import com.jobhunter.model.customenum.UserType;

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
    private String id; // 사용자 아이디 (고유값)
    private Long socialId; // 소셜 로그인 사용자 ID
    private String password; // 비밀번호
    private boolean remember; // 자동 로그인 여부
    private String autoLogin; // 자동 로그인 세션
    private UserType userType; // (NORMAL: 일반 사용자, COMPANY: 기업)
}
