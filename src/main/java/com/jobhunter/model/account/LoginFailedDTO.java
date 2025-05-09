package com.jobhunter.model.account;

import java.sql.Timestamp;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Setter
@ToString
@Builder
public class LoginFailedDTO {
	// 로그인에 실패 정보 담아둠
	
    private Timestamp blockTime; // 정지당해있을 시간
    private int loginFailCnt; // 실패한 횟수
    
}