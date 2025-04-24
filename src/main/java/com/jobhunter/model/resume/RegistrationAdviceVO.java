package com.jobhunter.model.resume;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class RegistrationAdviceVO {
	private int rgAdviceNo;
    private Timestamp regDate;
    private String status;
    private String title;
    private int mentorUid;
    private int resumeNo;
    private int menteeUid;
}
