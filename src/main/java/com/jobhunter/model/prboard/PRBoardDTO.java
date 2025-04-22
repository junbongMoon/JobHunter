package com.jobhunter.model.prboard;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class PRBoardDTO {
	private int prBoardNo;
	private int useruid;
	private String title;
	private String writer;
	private String userId;
	private String introduce;


}
