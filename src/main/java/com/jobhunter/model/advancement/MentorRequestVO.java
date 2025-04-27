package com.jobhunter.model.advancement;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MentorRequestVO {
	private Integer advancementNo;    				// PK
    private String title;             				// 신청 글 제목
    private String writer;            				// 작성자 이름
    private Integer refUser;          				// 작성자 UID
    private Date postDate;            				// 작성일시
    private String content;           				// 글 내용
    private Status status;            				// 신청 상태
    private Date confirmDate;         				// 승인 완료일
    private String rejectMessage;     				// 반려 사유
    private List<MentorRequestUpFileVO> upfiles;	// 업로드 파일들

    public enum Status {
        PASS,
        FAILURE,
        CHECKED,
        WAITING
    }
}
