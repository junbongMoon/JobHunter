package com.jobhunter.model.account;

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
public class UnlockDTO {
	// 세션에 넣어둘 사용자 정보
	private Integer uid; // 사용자 고유 ID
    private String mobile; // 전화번호
    private String email; // 이메일
    private AccountType accountType; // 회원 유형 (USER: 일반 사용자, COMPANY: 기업)
    private Integer loginCnt; // 로그인 실패 횟수
    
	public UnlockDTO(AccountVO acc) {
		this.uid = acc.getUid();
		this.mobile = acc.getMobile();
		this.email = acc.getEmail();
		this.accountType = acc.getAccountType();
		this.loginCnt = acc.getLoginCnt();
	}
    
    
}
