package com.jobhunter.model.resume;

import lombok.Data;

@Data
public class MyRegistrationAdviceSearchDTO {
	private int uid;
	private Status status;
	private String type;
	private int page;
	
	public int getOffset() {
		return (page - 1) * 5;
	}
	
	public String getStatusName() {
        return status != null ? status.name() : null;
    }
	
	public enum Status {
		COMPLETE,
		CANCEL,
		WAITING,
		CHECKING,
		LIVE
    }
}
