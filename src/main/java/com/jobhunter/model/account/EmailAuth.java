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
@Builder
@Getter
@Setter
@ToString
public class EmailAuth {
	private String code;
    private Timestamp expireAt;
    // 이메일 인증코드랑 만료시간 저장해두는 객체
}
