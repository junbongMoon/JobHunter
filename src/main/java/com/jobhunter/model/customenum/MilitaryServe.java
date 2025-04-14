package com.jobhunter.model.customenum;

/**
 * 병역 사항 (NOT_COMPLETED: 미필, COMPLETED: 군필, EXEMPTED: 면제)
 */
public enum MilitaryServe {
    NOT_SERVED, // 미필
    SERVED, // 군필
    EXEMPTED, // 면제
    COMPLETED, // 임시_추후 회의통해 DB 통일 후 삭제 필요
    NOT_COMPLETED // 임시_추후 회의통해 DB 통일 후 삭제 필요
}
