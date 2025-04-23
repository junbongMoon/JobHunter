package com.jobhunter.model.submit;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class SubmitFromUserVO {
	private int registrationNo;     // 신청 고유번호
    private Status status;          // 신청 상태 (WAITING 등)
    private Timestamp regDate;      // 신청 일자

    private int resumeNo;           // 이력서 번호
    private String resumeTitle;     // 이력서 제목
    
    private int recruitNo;          // 공고 번호
    private String recruitTitle;    // 공고 제목
    
    public String getStatusDisplayName() {
        return status != null ? status.getDisplayName() : "";
    }
}
