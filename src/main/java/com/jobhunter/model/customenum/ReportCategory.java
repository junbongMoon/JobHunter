package com.jobhunter.model.customenum;

public enum ReportCategory {
    SPAM("스팸/광고성 메시지"),
    HARASSMENT("욕설/괴롭힘"),
    FALSE_INFO("허위 정보"),
    ILLEGAL_ACTIVITY("불법 행위"),
    INAPPROPRIATE_CONTENT("부적절한 프로필/사진"),
    MISCONDUCT("부적절한 행동/요구"),
	ETC("기타 사유");

    private final String displayName;

    ReportCategory(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
