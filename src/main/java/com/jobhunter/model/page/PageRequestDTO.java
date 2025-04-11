package com.jobhunter.model.page;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author Administrator
 *
 */
@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PageRequestDTO {
	/**
	 * <p>
	 * 현재 페이지 번호
	 * </p>
	 */
	private int pageNo = 1;
	/**
	 * <p>
	 * 1페이지당 보여줄 row의 수
	 * </p>
	 */
	private int rowCntPerPage = 10;

	/**
	 * <p>
	 * 검색할 타입
	 * </p>
	 */
	private String searchType;
	/**
	 * <p>
	 * 검색어
	 * </p>
	 */
	private String searchWord;

	/**
	 * <p>
	 * 정렬 기준
	 * </p>
	 */
	private String sortOption;
}
