package com.jobhunter.model.region;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@ToString
public class Region {
	// 코드 말고 regionNo로 사용할 것.
	private int regionNo;
	private String code;
	private String name;
}
