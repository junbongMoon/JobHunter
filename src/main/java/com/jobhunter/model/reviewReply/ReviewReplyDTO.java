package com.jobhunter.model.reviewReply;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class ReviewReplyDTO {
	
		private int replyNo;
		private int boardNo;
		private int userId;
		private String writerId; // users 테이블의 userId
		private String content;
		private int likes;
		@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd")
		private LocalDateTime postDate;
		private Timestamp updatedAt;
	

}
