package com.jobhunter.model.account;

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
public class AccountVO {
	// 세션에 넣어둘 사용자 정보
	private Integer uid; // 사용자 고유 ID
    private String accountName; // 사용자 이름
    private String accountId; // 사용자 아이디 (고유값)
    private Long socialId; // 소셜 로그인 사용자 ID
    private String mobile; // 전화번호
    private String email; // 이메일
    private String autoLogin; // 자동 로그인 여부 (세션 정보)
    private AccountType accountType; // 회원 유형 (USER: 일반 사용자, COMPANY: 기업)
    private String requiresVerification; // 인증 필요 여부 ("Y" 또는 "N")
    private Timestamp blockDeadline; // 계정 정지 기한
    private Timestamp deleteDeadline; // 계정 삭제 대기 기한
    private String blockReason; // 계정 정지 사유
    private Integer loginCnt; // 로그인 실패 횟수
    private Character isSocial; // 소셜 로그인 여부 ("Y": 소셜 로그인 사용자, "N": 일반 사용자)
    private Character isAdmin; //  관리자 권한 ("Y": 관리자, "N": 일반 사용자)
}
