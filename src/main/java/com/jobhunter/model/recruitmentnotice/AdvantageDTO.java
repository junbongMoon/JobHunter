package com.jobhunter.model.recruitmentnotice;

import com.jobhunter.model.customenum.Method;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Setter
@Getter
@ToString
@Builder
public class AdvantageDTO {
	// 우대조건 내용
		private String advantageType;
		// 공고글 pk 참조
		private int recruitmentNoticeUid;

}
