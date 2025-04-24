package com.jobhunter.model.resume;

import lombok.Data;

@Data
public class MyRegistrationAdviceSearchDTO {
	private int uid;
	private String status;
	private String type;
	private int page;
	
	public int getOffset() {
		return (page - 1) * 5;
	}
}
