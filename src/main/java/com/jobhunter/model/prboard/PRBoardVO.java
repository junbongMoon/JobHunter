package com.jobhunter.model.prboard;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PRBoardVO {
	private int prBoardNo;
	private int useruid;
	private String title;
	private String writer;
	private String userId;
	private String introduce;
	private LocalDateTime postDate;
	
	public String getFormattedPostDate() {
	    return postDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}

}
