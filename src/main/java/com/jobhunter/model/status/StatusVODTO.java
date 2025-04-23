package com.jobhunter.model.status;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @author Administrator
 * 
 * <p>잡헌터 일일 통계</p>
 *
 */
@Data
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class StatusVODTO {

	/**
	 * <p> 
	 * 고유 값
	 * </p>
	 */
	private int statusNo;

	/**
	 * <p> 
	 * 통계 일자
	 * </p>
	 */
	private LocalDateTime statusDate;

	/**
	 * <p> 
	 * 신규 유저 수
	 * </p>
	 */
	private int newUsers;
	/**
	 * <p> 
	 * 신규 기업 수
	 * </p>
	 */
	private int newCompanies;
	/**
	 * <p> 
	 * 신규 공고 수
	 * </p>
	 */
	private int newRecruitmentNoticeCnt;
	/**
	 * <p> 
	 * 신규 제출 수
	 * </p>
	 */
	private int newRegistration;
	/**
	 * <p> 
	 * 신규 리뷰글 수
	 * </p>
	 */
	private int newReviewBoard;
	
    public String getFormattedDate() {
        return statusDate != null ? statusDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) : "날짜 없음";
    }

}
