package com.jobhunter.model.customenum;

public enum JobForm {
    FULL_TIME("정규직"),
    CONTRACT("계약직"),
    DISPATCH("파견직"),
    PART_TIME("아르바이트"),
    COMMISSION("위촉직"),
    FREELANCE("프리랜서");

    private final String displayName;

    JobForm(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
} 