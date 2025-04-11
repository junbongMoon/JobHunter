package com.jobhunter.model.region;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * @author 문준봉
 *
 */
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Getter
@ToString
public class Region {
	
	/**
	 * <p> 
	 * 도시 정보의 pk
	 * </p>
	 */
	private int regionNo;
	/**
	 * <p> 
	 * 저장된 코드 값
	 * </p>
	 */
	private String code;
	/**
	 * <p> 
	 * 도시 이름
	 * </p>
	 */
	private String name;
}
