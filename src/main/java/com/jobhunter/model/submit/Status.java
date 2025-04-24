package com.jobhunter.model.submit;

public enum Status {
	PASS("합격"),
	FAILURE("불합격"),
	EXPIRED("기간만료"),
	CHECKED("검토중"),
	WAITING("미확인");
	

    private final String displayName;

    Status(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
