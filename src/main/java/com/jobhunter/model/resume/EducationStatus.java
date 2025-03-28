package com.jobhunter.model.resume;

public enum EducationStatus {
    GRADUATED("졸업"),
    ENROLLED("재학중"),
    ON_LEAVE("휴학중"),
    DROPPED_OUT("중퇴");

    private final String displayName;

    EducationStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
} 