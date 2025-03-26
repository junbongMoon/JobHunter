package com.jobhunter.model.resume;

public enum EducationLevel {
    HIGH_SCHOOL("고등학교"),
    JUNIOR_COLLEGE("전문대학"),
    UNIVERSITY("대학교"),
    GRADUATE("대학원");

    private final String displayName;

    EducationLevel(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
} 