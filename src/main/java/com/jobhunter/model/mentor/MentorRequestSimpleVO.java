package com.jobhunter.model.mentor;

import java.util.Date;

import lombok.Data;

@Data
public class MentorRequestSimpleVO {
	private Integer advancementNo;    // PK
    private String title;             // 신청 글 제목
    private String writer;            // 작성자 이름
    private Integer refUser;          // 작성자 UID
    private Date postDate;            // 작성일시
    private Status status;            // 신청 상태
    private Date confirmDate;         // 승인 완료일
    private String rejectMessage;     // 반려 사유

    public enum Status {
        PASS,
        FAILURE,
        CHECKED,
        WAITING
    }
}
