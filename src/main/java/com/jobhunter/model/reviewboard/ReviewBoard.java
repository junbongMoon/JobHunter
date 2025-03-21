package com.jobhunter.model.reviewboard;

import java.sql.Timestamp;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor(access =AccessLevel.PROTECTED)
@Builder // 객체를 만들 때 정해진 패턴대로 생성하도록 Builder 패턴을 사용
@Getter
@Setter
@ToString
public class ReviewBoard {
	private int boardNo;
	private String gonggrioUid;
	private int writer;
	private String companyName;
	private ReviewResult reviewResult;
	private ReviewType reviewType;
	private int reviewLevel;
	private String content;
	private String category;
	private JobType jobType;
	private Timestamp postDate;
	private int likes;
	private int views;
}
