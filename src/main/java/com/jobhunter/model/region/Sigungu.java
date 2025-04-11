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

	/**
	 * <p> 
	 * 시군구 pk 값
	 * </p>
	 */
	private int sigunguNo;
	
	/**
	 * <p> 
	 * 시군구의 코드 값
	 * </p>
	 */
	private String code;
	/**
	 * <p> 
	 * 시군구 이름
	 * </p>
	 */
	private String name;
	
	/**
	 * <p> 
	 * 이 시군구가 위치한 도시의 pk값
	 * </p>
	 */
	private int regionNo;
}
