package com.jobhunter.model.reviewboard;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReviewBoardWithReplyVO {
	private int boardNo;
	private String companyName;
	private String content;
	private Timestamp postDate;
	private int likes;
	private int views;
	
	//댓글 갯수
	private int replyCnt;
}
