package com.jobhunter.model.submit;

import lombok.Data;

@Data
public class SubmitSearchDTO {
	private int Uid;
	private int recruitmentUid;
	private int page;
	private boolean onlyUnread;        // 읽지 않은 것만 보기
	private boolean prioritizeUnread;  // 읽지 않은 것 먼저 정렬

	public int getOffset() {
		return (page - 1) * 5;
	}
}
