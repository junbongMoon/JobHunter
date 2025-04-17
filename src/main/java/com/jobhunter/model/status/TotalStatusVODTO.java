package com.jobhunter.model.status;

import java.time.LocalDateTime;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data  // getter/setter, toString, equals 등 자동 생성
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class TotalStatusVODTO {

    /**
     * pk 값
     */
    private int totalStatusNo; // PK
    /**
     * 통계 생성 날짜
     */
    private LocalDateTime statusDate;

    /**
     * 총 유저 수 
     */
    private int totalUsers;
    /**
     * 총 기업 수
     */
    private int totalCompanies;
    /**
     * 총 공고 수
     */
    private int totalRecruitmentNoticeCnt;
    /**
     * 총 제출 수
     */
    private int totalRegistration;
    /**
     * 총 리뷰 수
     */
    private int totalReviewBoard;
    
    
    
    public String getFormattedDate() {
        return statusDate.toLocalDate().toString(); // 또는 DateTimeFormatter.ofPattern("yyyy-MM-dd") 적용 가능
    }
}