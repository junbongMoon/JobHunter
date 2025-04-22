package com.jobhunter.model.submit;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class SubmitFromRecruitVO {
	private int registrationNo;     // 신청 고유번호
    private String status;          // 신청 상태 (WAITING 등)
    private Timestamp regDate;      // 신청 일자

    private int resumeNo;           // 이력서 번호
    private String title;           // 이력서 제목

    private String userName;        // 작성자 이름 (users 테이블)
}
