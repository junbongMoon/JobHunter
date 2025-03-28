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
public class Sigungu {
	// 시군구 pk 값
	private int sigunguNo;
	private String code;
	// 시군구 이름
	private String name;
	// 이 시군구가 위치한 도시의 pk값
	private int regionNo;
}
