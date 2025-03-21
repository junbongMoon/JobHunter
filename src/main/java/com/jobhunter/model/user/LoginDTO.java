package com.jobhunter.model.user;

import java.sql.Timestamp;

import com.jobhunter.model.customenum.Gender;
import com.jobhunter.model.customenum.MilitaryService;
import com.jobhunter.model.customenum.Nationality;
import com.jobhunter.model.customenum.UserType;

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
public class LoginDTO {
    private String userId; // 사용자 아이디 (고유값)
    private Long socialId; // 소셜 로그인 사용자 ID
    private String password; // 비밀번호
    private boolean remember; // 자동 로그인 여부
    private String autoLogin; // 자동 로그인 세션

}
