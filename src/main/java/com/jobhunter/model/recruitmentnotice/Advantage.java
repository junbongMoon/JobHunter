package com.jobhunter.model.recruitmentnotice;

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
// 우대조건
public class Advantage {
	// pk 값
	private int advantageNo;
	// 우대조건 내용
	private String advantageType;
	// 공고글 pk 참조
	private int recruitmentNoticeUid;

}
