package com.jobhunter.model.message;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 메시지 전송을 위한 사용자 정보 DTO
 */
@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class MessageTargetInfoDTO {

    private int userNo;
    private int companyNo;
    private String companyName;
    private String noticeTitle;
}
